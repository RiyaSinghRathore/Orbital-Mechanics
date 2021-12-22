function rotating_matrix = fun_rotating_to_inertial_matrix(C, dtheta_dt)
% C          : the rotating matrix of the position from a rotating frame to the intertial frame, 3×3
% dtheta_dt  ; the time variation of theta, theta is the rotating angle, [1/s]

  rotating_matrix = [C(1,1) C(1,2) C(1,3) 0 0 0;
                     C(2,1) C(2,2) C(2,3) 0 0 0;
                     C(3,1) C(3,2) C(3,3) 0 0 0;
                     dtheta_dt*C(1,2) -dtheta_dt*C(1,1) 0 C(1,1) C(1,2) C(1,3);
                     dtheta_dt*C(2,2) -dtheta_dt*C(2,1) 0 C(2,1) C(2,2) C(2,3);
                     dtheta_dt*C(3,2) -dtheta_dt*C(3,1) 0 C(3,1) C(3,2) C(3,3)];
end