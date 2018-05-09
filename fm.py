def two_mirror_system(alpha1x, alpha1y, alpha2x, alpha2y, rev1, rev2, d_m1_m2, d_m2_s1, d_s1_s2):
    delta_1 = d_m1_m2 + d_m2_s1
    print(delta_1)
    delta_s2 = d_m2_s1 + d_s1_s2
    print(delta_s2)
    delta_s1 = d_m2_s1
    delta_max = d_m1_m2+ d_s1_s2 + delta_s1
    print(delta_max)
    c_alphax1, c_alphay1, c_alphax2, c_alphay2 = np.cos(np.deg2rad(alpha1x)) , np.cos(np.deg2rad(alpha1y)) ,np.cos(np.deg2rad(alpha2x)) , np.cos(np.deg2rad(alpha2y))
    c_rev1, s_rev1, c_rev2, s_rev2 = np.cos(np.deg2rad(rev1)) , np.sin(np.deg2rad(rev1)) ,np.cos(np.deg2rad(rev2)) , np.sin(np.deg2rad(rev2))
    
    system = np.matrix([  
        [ 2*delta_1*c_alphax1*c_rev1, -2*delta_1*c_alphax1*s_rev1, 2*delta_s1*c_alphax2*c_rev2, -2*delta_s1*c_alphax2*s_rev2],
        
        [2*delta_1*c_alphay1*s_rev1, 2*delta_1*c_alphay1*c_rev1, 2*delta_s1*c_alphay2*s_rev2, 2*delta_s1*c_alphay2*c_rev2], 
        
        [2*delta_max*c_alphax1*c_rev1, -2*delta_max*c_alphax1*s_rev1, 2*delta_s2*c_alphax2*c_rev2, -2*delta_s2*c_alphax2*s_rev2],
        
        [2*delta_max*c_alphay1*s_rev1, 2*delta_max*c_alphay1*c_rev1, 2*delta_s2*c_alphay2*s_rev2, 2*delta_s2*c_alphay2*c_rev2]
        ])
    
    return(system)
    
def angle_variation(ccd1x, ccd1y, ccd2x, ccd2y, f_matrix):
    pred_alpha1x = []
    pred_alpha1y = []
    pred_alpha2x = []
    pred_alpha2y = []
    for i in range(len(ccd1x)):
        curr_offset_vector =ccd1x[i], ccd1y[i], ccd2x[i], ccd2y[i]
        inv_f = np.linalg.inv(f_matrix)
        curr_angle_vector = np.rad2deg(np.matmul(inv_f, np.transpose(curr_offset_vector)))
        #print((curr_angle_vector))
        pred_alpha1x.append(curr_angle_vector.item(0))
        pred_alpha1y.append(curr_angle_vector.item(1))
        pred_alpha2x.append(curr_angle_vector.item(2))
        pred_alpha2y.append(curr_angle_vector.item(3))
    
    return(pred_alpha1x, pred_alpha1y, pred_alpha2x, pred_alpha2y)
        
        
def offset_prediction(var_1x, var_1y, var_2x, var_2y, f_matrix): 
    pred_dx1 = []
    pred_dx2 = []
    pred_dy1 = []
    pred_dy2 = []
    for i in range(len(var_1x)):
        angle_var_vec = var_1x[i], var_1y[i], var_2x[i], var_2y[i]
        curr_offset_vector = np.matmul(f_matrix, np.deg2rad(np.transpose(angle_var_vec)))
        print(curr_offset_vector)
        pred_dx1.append(curr_offset_vector.item(0))
        pred_dy1.append(curr_offset_vector.item(1))
        pred_dx2.append(curr_offset_vector.item(2))
        pred_dy2.append(curr_offset_vector.item(3))
    return(pred_dx1, pred_dy1, pred_dx2, pred_dy2)

