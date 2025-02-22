function [f_adaptive, step_size, denoised_signal] = FastBlockLMS_with_output(Pnum, d, u, s, f, fs, output_file_name)
    L = 512;
    N = size(f,2);
    M = length(u);
    Nframes = fix(M/L);
    w_temp = zeros(L,1);
    W_temp = zeros(2*L,1);
    P = 0;
    gamma = 0.9;
    MSE_buff = zeros(M-size(f,2)+1,4);
    fprintf('Iteration:    ');
    n = 1;
    e_final = inf;

    for num = 1
        fprintf('\b\b\b\b%4d', num);
        e = zeros(M,1);
        step_size_temp = 0.1 * num;
        for i = 1 : Nframes - 1
            if i == 0
                Uvec = fft([zeros(L-1,1); u(1:L)], 2*L);
            else
                Uvec = fft((u((i-1)*L+1:(i+1)*L)),2*L);
            end
            yvec = ifft(Uvec.*W_temp);
            yvec = yvec(L+1 : 2*L, 1);
            dvec = d(i*L+1 : (i+1)*L);
            e(i*L+1:(i+1)*L, 1) = dvec-yvec;
            Evec = fft([zeros(L,1); e(i*L+1:(i+1)*L)], 2*L);
            P = gamma * P + (1-gamma)*abs(Uvec).^2;
            Dvec = 1./P ;
            g = ifft(Dvec.*conj(Uvec).*Evec,2*L);
            g = g(1:L);
            g = fft([g;zeros(L,1)], 2*L);
            W_temp = W_temp + step_size_temp*g;
        end
        w_temp = ifft(W_temp);
        w_temp = real(w_temp(1:length(W_temp)/2));
        e = real(e(:));
        if e_final > sum(abs(e-s).^2,1)
            e_final = sum(abs(e).^2,1);
            error = e;
            step_size = step_size_temp;
            w = w_temp;
        end
    end
    f_adaptive = w;
    denoised_signal = d - filter(f_adaptive, 1, u);
    
    % Save the denoised output audio file
    audiowrite(output_file_name, denoised_signal, fs);

figure;
plot(MSE_buff(:,1), 'r--*', 'LineWidth', 1.5); hold on;
plot(MSE_buff(:,2), 'b--o', 'LineWidth', 1.5); 
plot(MSE_buff(:,3), 'g--+', 'LineWidth', 1.5); 
plot(MSE_buff(:,4), 'k--d', 'LineWidth', 1.5); 
hold off;
legend('step size : 0.001', 'step size : 0.01', 'step size : 0.1', 'step size : 1');
xlabel('Iteration');
ylabel('Mean Squared Error');
title('MSE Evolution for Different Step Sizes (Fast Block LMS)');
grid on;


end
