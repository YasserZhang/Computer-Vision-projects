function [K, R, t] = decompose_projection(P)
    %use QR factorization to decompose the projection matrix
    %assumption: projection matrix is invertible such that
    %QR factorization has unique result.
%     P = [KR | Kt];
%     P(1:3, 1:3)^(-1) = R^(-1)*K^(-1) = qr
%     R^(-1) = q => R = q^(-1)
%     K^(-1) = r => K = r^(-1)
%     Kt = P(:, 4) => t = K^(-1) * P(:, 4)
%     So, R = q^(-1), K = r^(-1), t = K^(-1) * P(:, 4)
    
    rotation_P = P(1:3, 1:3);
    translation_P = P(:, 4);
    inverse_rotation_P = inv(rotation_P);
    [q, r] = qr(inverse_rotation_P);
    inverse_K = r;
    R = inv(q);
    if det(R) < 0
        R = -R;
        inverse_K = -inverse_K;
    end
    K = inv(inverse_K);
    t = inverse_K * translation_P;
end