function caesar(text, k)
    alphabet=collect("абвгдеёжзийклмнопрстуфхцчшщъыьэюя")
    n = length(alphabet)
    encrypted_text = ""
    for c in text
        i = findfirst(isequal(c), alphabet)
        if i != nothing
            j = mod1(i + k, n)
            encrypted_text *= alphabet[j]
        else
            println("ОШИБКА СИМВОЛ", c, "НЕ ВХОДИТ В АЛФАВИТ")
            return
        end
    end
    return encrypted_text
end

function atbash(text)
    encrypted_text = ""
    for c in text
        alphabet=collect("абвгдеёжзийклмнопрстуфхцчшщъыьэюя")
        i = findfirst(isequal(c), alphabet)
        res = Char(1104 - i)
        encrypted_text *= res
    end
    return encrypted_text
end

s = caesar("привет",5)
println(s)

s = atbash("абвг")
println(s)
