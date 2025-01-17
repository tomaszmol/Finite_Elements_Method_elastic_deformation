
% Podana funkcja E(x) 
function y = E(x)
    if x <= 1
        y = 3;
    else
        y = 5;
    end
end

% Funkcja do obliczania e_i
function y = e(n, i, x)
    h = 2 / n;
    y = max(0, 1 - abs((x / h - i)));
end

% Funkcja która oblicza przybliżenie pochodnej e_1
function y = e_prim(n, i, x)
    h = 2 / n;
    if x <= (i - 1) * h | x >= (i + 1) * h  
        y = 0;
    else
        if x <= i * h
            y = 1 / h;
        else
            y = -1 / h;
        end
    end
end

% Funkcja, która oblicza całke dla wprowadzonych argumentow i oraz j 
function result = calculate_integral(n, i, j)
    start = 2 * max(max(i, j) - 1, 0) / n; %Obliczenie przedziałów całkowania
    finish = 2 * min(min(i, j) + 1, n) / n;
    
    if abs(j - i) <= 1
        % Dodanie opcjonalnej opcji ArrayValued=true, aby obsłużyć funkcje tablicowe
        % funkcja jest wbudowana funkcja w MATLABIE, rozwiazuje całkę
        % numerycznie i wykorzystuje algorytm oparty na adaptacyjnej kwadraturze Gaussa-Kronroda
        % zamiast zaproponowanej w rozwiazaniu kwadratury Gaussa-Legendra.
        result = integral(@(x) E(x) .* e_prim(n, i, x) .* e_prim(n, j, x), start, finish, 'ArrayValued', true);
    else
        result = 0;
    end
end


function [B, L] = fill(n)
    B = zeros(n, n);
    L = zeros(1, n);
    
    L(1) = -30 * e(n, 0, 0);
    
    for i = 1:n
        for j = 1:n
            integral = calculate_integral(n, i - 1, j - 1);  % w MATLAB indeksowanie zaczyna się od 1
            B(i, j) = -3 * e(n, i - 1, 0) * e(n, j - 1, 0) + integral;
        end
    end
end
function show_plot(solution, n)
    x = linspace(0, 2, n + 1);
    
    plot(x, solution, '-');
    title('Elastic deformation plot');
    xlabel('x');
    ylabel('u(x)');
    grid on;
    
    saveas(gcf, 'elastic_deformation_plot.pdf');
    % Optional: display the plot in MATLAB
    % figure;
end



% Główny blok kodu
user_input = input('Input n: ');

% Wywołanie funkcji fill i obliczenie macierzy B oraz L
[B, L] = fill(user_input);

% Rozwiązanie układu równań
solution = B \ L';  % Rozwiązywanie układu równań B * u = L

% Połączenie wektora solution z wartością 0 na końcu
solution = [solution; 0];

% Wywołanie funkcji do rysowania wykresu
show_plot(solution, user_input);




