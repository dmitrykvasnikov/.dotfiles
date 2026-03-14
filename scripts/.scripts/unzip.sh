#!/bin/bash

# Функция для определения, содержит ли распакованное содержимое только директории
contains_only_dirs() {
    local archive="$1"
    local temp_dir=$(mktemp -d)
    local result=0

    # Распаковываем архив во временную директорию с помощью 7z
    if command -v 7z &> /dev/null; then
        7z x "$archive" -o"$temp_dir" -y > /dev/null 2>&1
    elif command -v 7za &> /dev/null; then
        7za x "$archive" -o"$temp_dir" -y > /dev/null 2>&1
    elif command -v 7zz &> /dev/null; then  # для некоторых новых версий
        7zz x "$archive" -o"$temp_dir" -y > /dev/null 2>&1
    else
        echo "  ОШИБКА: 7z не найден. Установите p7zip."
        rm -rf "$temp_dir"
        return 1
    fi

    # Проверяем код возврата
    if [ $? -ne 0 ]; then
        rm -rf "$temp_dir"
        return 1
    fi

    # Проверяем, есть ли в корне распакованного содержимого файлы
    shopt -s dotglob  # Включаем обработку скрытых файлов
    for item in "$temp_dir"/*; do
        # Проверяем существует ли элемент (на случай пустой директории)
        [ -e "$item" ] || continue

        if [ -f "$item" ] || [ -L "$item" ]; then  # Если это файл или символическая ссылка
            result=1
            break
        fi
    done
    shopt -u dotglob

    rm -rf "$temp_dir"
    return $result
}

# Функция для извлечения имени без расширения
get_name_without_extension() {
    local filename="$1"
    local basename="${filename%.*}"

    # Обрабатываем двойные расширения (.tar.gz, .tar.bz2 и т.д.)
    if [[ "$filename" == *.tar.gz ]] || [[ "$filename" == *.tar.bz2 ]] || [[ "$filename" == *.tgz ]] || [[ "$filename" == *.tbz2 ]]; then
        basename="${filename%.*.*}"
    fi

    echo "$basename"
}

# Проверка наличия 7z
if ! command -v 7z &> /dev/null && ! command -v 7za &> /dev/null && ! command -v 7zz &> /dev/null; then
    echo "ОШИБКА: 7z не найден. Установите p7zip:"
    echo "  Ubuntu/Debian: sudo apt-get install p7zip-full"
    echo "  CentOS/RHEL: sudo yum install p7zip"
    echo "  Arch Linux: sudo pacman -S p7zip"
    exit 1
fi

# Основная часть скрипта
echo "Поиск архивов в текущей директории..."
echo "Используем 7z для распаковки"
echo "-----------------------------------"

# Подсчет обработанных архивов
count=0
errors=0

# Обрабатываем ZIP и RAR архивы через 7z, а также TAR и другие форматы
for archive in *.{zip,rar,tar,tar.gz,tgz,tar.bz2,tbz2,7z,gz,bz2,xz}; do
    # Проверяем существование файла (нужно из-за особенностей глоббинга)
    [ -f "$archive" ] || continue

    echo "[$((count+1))] Обработка: $archive"

    # Пропускаем, если это не файл
    if [ ! -f "$archive" ]; then
        echo "  Пропускаем (не файл)"
        continue
    fi

    # Проверяем структуру архива
    if contains_only_dirs "$archive"; then
        echo "  Архив содержит только папки -> распаковываем в текущую директорию"

        # Распаковка в текущую директорию
        if command -v 7z &> /dev/null; then
            7z x "$archive" -y > /dev/null 2>&1
        elif command -v 7za &> /dev/null; then
            7za x "$archive" -y > /dev/null 2>&1
        else
            7zz x "$archive" -y > /dev/null 2>&1
        fi

        if [ $? -eq 0 ]; then
            echo "  ✓ Успешно распакован"
            ((count++))
        else
            echo "  ✗ Ошибка распаковки"
            ((errors++))
        fi
    else
        dir_name=$(get_name_without_extension "$archive")
        echo "  Архив содержит файлы -> создаем директорию '$dir_name' и распаковываем туда"

        mkdir -p "$dir_name"

        # Распаковка в созданную директорию
        if command -v 7z &> /dev/null; then
            7z x "$archive" -o"$dir_name" -y > /dev/null 2>&1
        elif command -v 7za &> /dev/null; then
            7za x "$archive" -o"$dir_name" -y > /dev/null 2>&1
        else
            7zz x "$archive" -o"$dir_name" -y > /dev/null 2>&1
        fi

        if [ $? -eq 0 ]; then
            echo "  ✓ Успешно распакован в '$dir_name'"
            ((count++))
        else
            echo "  ✗ Ошибка распаковки"
            # Удаляем пустую директорию в случае ошибки
            rmdir "$dir_name" 2>/dev/null
            ((errors++))
        fi
    fi

    echo "-----------------------------------"
done

# Проверяем, были ли найдены архивы
if [ $count -eq 0 ] && [ $errors -eq 0 ]; then
    echo "Архивы не найдены в текущей директории."
else
    echo "Готово! Обработано архивов: $count, ошибок: $errors"
fi

