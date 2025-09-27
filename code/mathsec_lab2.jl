
function rot90(matrix, k=1)
    for _ in 1:k

        matrix = permutedims(reverse(matrix, dims=1))
    end
    return matrix
end

function route(text, password)
    encrypted_text = ""
    text = replace(lowercase(text), " " => "")
    n = length(password)
    if length(text) % n != 0
        text *= 'a'^(n - length(text) % n)
    end
    m = length(text) ÷ n
    col_order = sortperm(collect(password))
    chars = collect(text)
    matrix = [chars[(i-1)*n + j] for i in 1:m, j in 1:n]

    for col in col_order
        for i in 1:m
            encrypted_text *= matrix[i, col]
        end
    end
    return uppercase(encrypted_text)
end

function generate_mesh(k)
    base = reshape(1:k^2, k, k)
    rot_90 = rot90(base, 1)
    rot_180 = rot90(base, 2)
    rot_270 = rot90(base, 3)

    top = hcat(base, rot_90)
    bottom = hcat(rot_270, rot_180)
    return vcat(top, bottom)
end

function mesh_encrypt(text, password, k)
    encrypted_text = ""
    text = replace(lowercase(text), " " => "")
    password = lowercase(password)
    
    if length(password) != k^2
        println("ОШИБКА! НЕВЕРНЫЕ РАЗМЕРНОСТИ")
        return
    end
    
    target = 4*k^2
    
    chars = collect(text)
    
    if length(chars) < target

        append!(chars, fill('а', target - length(chars)))
    elseif length(chars) > target
        chars = chars[1:target]
    end

    mesh = generate_mesh(k)
    matrix = Matrix{Char}(undef, 2*k, 2*k)

    pos = 1
    for rot in 0:3
        cur_mesh = rot90(mesh, rot)
        for i in 1:2*k, j in 1:2*k
            if cur_mesh[i, j] <= k^2 && pos <= length(chars)
                matrix[i,j] = chars[pos]
                pos += 1
            end
        end
    end

    order = sortperm(collect(password))
    for col in order
        for i in 1:2*k
            encrypted_text *= matrix[i, col]
        end
    end
    return uppercase(encrypted_text)
end

text = "Нельзя недооценивать противника"
println("Маршрутное шифрование:")
println(route(text,"пароль"))
println()
println("Шифрование решетками:")
result = mesh_encrypt("Договор подписали", "шифр", 2)
println(result)

function vigener(text, password)
    alphabet=collect("абвгдежзийклмнопрстуфхцчшщыьэюя")
    text = replace(lowercase(text), " " => "")
    password = collect(lowercase(password))
    
    repeated = ""
    for i in 1:length(text)
        repeated *= password[mod1(i, length(password))]
    end
    text = collect(text)
    repeated = collect(repeated)
    encrypted_text = ""
    for i in 1:length(text)
        text_i = findfirst(isequal(text[i]), alphabet)
        pass_i = findfirst(isequal(repeated[i]), alphabet)
        if text_i != nothing && pass_i != nothing
            new_i = mod1(text_i + pass_i - 1, length(alphabet))
            encrypted_text *= alphabet[new_i]
        else
            println("ОШИБКА! СИМВОЛА ", text[i], " или ", repeated[i], " НЕТ В АЛФАВИТЕ")
            return
        end
    end
    return uppercase(encrypted_text)
end

println("Таблица Виженера")
println(vigener("криптография серьезная наука", "математика"))