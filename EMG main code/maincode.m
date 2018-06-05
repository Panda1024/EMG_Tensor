
people_number = 8;
motion_number = 29;
time_norm_frame = 50;



for p =1 : people_number %% 사람 수
    for m =1 :motion_number %% 모션 수
       
        test = c3dserver;
        
        if p == 1
               openc3d(test,1,sprintf('BYPark#%d.c3d',m));
        elseif p == 2
       
            openc3d(test,1,sprintf('JKYim#%d.c3d',m));
        elseif p == 3
   
             openc3d(test,1,sprintf('JMLee#%d.c3d',m));
        elseif p == 4
   
             openc3d(test,1,sprintf('JWKim#%d.c3d',m));
        elseif p == 5
   
             openc3d(test,1,sprintf('MSKim#%d.c3d',m));
        elseif p == 6

            openc3d(test,1,sprintf('SHShin#%d.c3d',m));
        elseif p == 7
            openc3d(test,1,sprintf('WJChoi#%d.c3d',m));
        elseif p == 8
            openc3d(test,1,sprintf('YMHa#%d.c3d',m));
        end
        
        data = get3dtargets(test);
        angle_f = [];
        
        for f = 1 : length(data.A0(:,1))
            angle = [];


            vec_a01 = (data.A1(f,:) - data.A0(f,:));
            vec_b0c0 = (data.B0(f,:) - data.D0(f,:));
            vec_a0b0 = (data.A0(f,:) - data.B0(f,:));
            
            vec_a12 = (data.A2(f,:) - data.A1(f,:));
            vec_a23 = (data.A3(f,:) - data.A2(f,:));
%             vec_a34 = (data.A4(f,:) - data.A3(f,:));

            vec_b01 = (data.B1(f,:) - data.B0(f,:));
            vec_b12 = (data.B2(f,:) - data.B1(f,:));
            vec_b23 = (data.B3(f,:) - data.B2(f,:));
            vec_b34 = (data.B4(f,:) - data.B3(f,:));

            vec_c01 = (data.C1(f,:) - data.C0(f,:));
            vec_c12 = (data.C2(f,:) - data.C1(f,:));
            vec_c23 = (data.C3(f,:) - data.C2(f,:));
            vec_c34 = (data.C4(f,:) - data.C3(f,:));

            vec_d01 = (data.D1(f,:) - data.D0(f,:));
            vec_d12 = (data.D2(f,:) - data.D1(f,:));
            vec_d23 = (data.D3(f,:) - data.D2(f,:));
            vec_d34 = (data.D4(f,:) - data.D3(f,:));
            
            vec_e01 = (data.E1(f,:) - data.E0(f,:));
            vec_e12 = (data.E2(f,:) - data.E1(f,:));
            vec_e23 = (data.E3(f,:) - data.E2(f,:));
            vec_e34 = (data.E4(f,:) - data.E3(f,:));
            
            vec_a01 = vec_a01/norm(vec_a01);
            vec_a12 = vec_a12/norm(vec_a12);
            vec_a23 = vec_a23/norm(vec_a23);
%             vec_a34 = vec_a34/norm(vec_a34);
            
            vec_b01 = vec_b01/norm(vec_b01);
            vec_b12 = vec_b12/norm(vec_b12);
            vec_b23 = vec_b23/norm(vec_b23);
            vec_b34 = vec_b34/norm(vec_b34);
            
            vec_c01 = vec_c01/norm(vec_c01);
            vec_c12 = vec_c12/norm(vec_c12);
            vec_c23 = vec_c23/norm(vec_c23);
            vec_c34 = vec_c34/norm(vec_c34);
            
            vec_d01 = vec_d01/norm(vec_d01);
            vec_d12 = vec_d12/norm(vec_d12);
            vec_d23 = vec_d23/norm(vec_d23);
            vec_d34 = vec_d34/norm(vec_d34);
            
            
            vec_e01 = vec_e01/norm(vec_e01);
            vec_e12 = vec_e12/norm(vec_e12);
            vec_e23 = vec_e23/norm(vec_e23);
            vec_e34 = vec_e34/norm(vec_e34);

            ref_axis = data.B1(f,:)-data.C1(f,:);
            ref_axis = ref_axis/norm(ref_axis);
            ref_axis2 = cross(data.B0(f,:)-data.C0(f,:),data.D0(f,:)-data.C0(f,:));
            ref_axis2 = ref_axis2/norm(ref_axis2);
            
            angle_a1 = acos((vec_a0b0*vec_b0c0')/(norm(vec_a0b0)*norm(vec_b0c0)));
            angle_a2 = acos((vec_a01*vec_a12')/(norm(vec_a12)*norm(vec_a01)));
            angle_a3 = acos((vec_a23*vec_a12')/(norm(vec_a23)*norm(vec_a12)));

            angle_b1 = acos((vec_b01*vec_b12')/(norm(vec_b01)*norm(vec_b12)));
            angle_b2 = acos((vec_b12*vec_b23')/(norm(vec_b12)*norm(vec_b23)));
            angle_b3 = acos((vec_b23*vec_b34')/(norm(vec_b23)*norm(vec_b34)));

            angle_c1 = acos((vec_c01*vec_c12')/(norm(vec_c01)*norm(vec_c12)));
            angle_c2 = acos((vec_c12*vec_c23')/(norm(vec_c12)*norm(vec_c23)));
            angle_c3 = acos((vec_c23*vec_c34')/(norm(vec_c23)*norm(vec_c34)));

            angle_d1 = acos((vec_d01*vec_d12')/(norm(vec_d01)*norm(vec_d12)));
            angle_d2 = acos((vec_d12*vec_d23')/(norm(vec_d12)*norm(vec_d23)));
            angle_d3 = acos((vec_d23*vec_d34')/(norm(vec_d23)*norm(vec_d34)));

            angle_e1 = acos((vec_e01*vec_e12')/(norm(vec_e01)*norm(vec_e12)));
            angle_e2 = acos((vec_e12*vec_e23')/(norm(vec_e12)*norm(vec_e23)));
            angle_e3 = acos((vec_e23*vec_e34')/(norm(vec_e23)*norm(vec_e34)));
                    
            axis_b1 = cross(vec_b01, vec_b12)/norm(cross(vec_b01, vec_b12));
            axis_b2 = cross(vec_b12, vec_b23)/norm(cross(vec_b12, vec_b23));
            axis_b3 = cross(vec_b23, vec_b34)/norm(cross(vec_b23, vec_b34));
            
            axis_c1 = cross(vec_c01, vec_c12)/norm(cross(vec_c01, vec_c12));
            axis_c2 = cross(vec_c12, vec_c23)/norm(cross(vec_c12, vec_c23));
            axis_c3 = cross(vec_c23, vec_c34)/norm(cross(vec_c23, vec_c34));
    
            axis_d1 = cross(vec_d01, vec_d12)/norm(cross(vec_d01, vec_d12));
            axis_d2 = cross(vec_d12, vec_d23)/norm(cross(vec_d12, vec_d23));
            axis_d3 = cross(vec_d23, vec_d34)/norm(cross(vec_d23, vec_d34));
            
             for a = 1 : 3
                    eval(sprintf('angle_a%d = abs(angle_a%d);',a,a));
                
                
                if eval(sprintf('acos(ref_axis*transpose(axis_b%d))<pi/2',a))
                    eval(sprintf('angle_b%d = angle_b%d;',a,a));
                else
                    eval(sprintf('angle_b%d = -angle_b%d;',a,a));
                end
                
                if eval(sprintf('acos(ref_axis*transpose(axis_c%d))<pi/2',a))
                    eval(sprintf('angle_c%d = angle_c%d;',a,a));
                else
                    eval(sprintf('angle_c%d = -angle_c%d;',a,a));
                end
                if eval(sprintf('acos(ref_axis*transpose(axis_d%d))<pi/2',a))
                    eval(sprintf('angle_d%d = angle_d%d;',a,a));
                else
                    eval(sprintf('angle_d%d = -angle_d%d;',a,a));
                end
                  if eval(sprintf('acos(ref_axis*transpose(axis_d%d))<pi/2',a))
                    eval(sprintf('angle_e%d = angle_e%d;',a,a));
                else
                    eval(sprintf('angle_e%d = -angle_e%d;',a,a));
                end
             end
            
            angle = vertcat(angle,angle_a1);
            angle = vertcat(angle,angle_a2);
            angle = vertcat(angle,angle_a3);
            angle = vertcat(angle,angle_b1);
            angle = vertcat(angle,angle_b2);
            angle = vertcat(angle,angle_b3);
            angle = vertcat(angle,angle_c1);
            angle = vertcat(angle,angle_c2);
            angle = vertcat(angle,angle_c3);
            angle = vertcat(angle,angle_d1);
            angle = vertcat(angle,angle_d2);
            angle = vertcat(angle,angle_d3);
            angle = vertcat(angle,angle_e1);
            angle = vertcat(angle,angle_e2);
            angle = vertcat(angle,angle_e3);


            angle_f = horzcat(angle_f,angle);
        end
        
            static_angle = angle_f(:,1);
        
%         eval(sprintf('angle_%d_%d = angle_f;',p,m));  %
          eval(sprintf('angle_%d_%d = angle_f - repmat(static_angle,1,length(data.A1));',p,m)) ;
        
    end
end
%%

people_number = 8;
motion_number = 29;
time_norm_frame = 50;


%%%%%%%%%%%%%%%%%%%%%%%%time normalization 시작 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for p = 1 : people_number
    for m = 1 : motion_number
        eval(sprintf('lin_angle_%d_%d = sort_posi(angle_%d_%d);',p,m,p,m));
    end
end
% 
% for p = 1 : people_number-1 %%영민 제외
%     for m = 1 : motion_number
%         eval(sprintf('[t_warping,r_warping,t_time,r_time] = Dynamic_Time_warping_matrix(transpose(angle_%d_%d),transpose(ref_angle_%d));',p,m,m));
%         eval(sprintf('dtw_angle_%d_%d = t_warping;',p,m));
%         
%     end
% end



%%
motion_number = 29;
people_number = 8;
gallery_tensor = zeros(15,(motion_number-1)*100,people_number);

for p = 1 : 8
    for m = 2 : 29
        eval(sprintf('gallery_tensor(:,%d*100-99:%d*100,%d) = lin_angle_%d_%d;',m-1,m-1,p,p,m));
    end
end

gallery_tensor = tensor(gallery_tensor);

% gallery_tensor = gallery_tensor(:,46:50,1:12,2);
gallery_tensor2 = gallery_tensor;
gallery_tensor = gallery_tensor2(:,[1:2800],[2 3 4 6 8 ]);
% gallery_tensor = gallery_tensor2(:,[1:2800],[1:7]);
%%%%%%%%%%%%%%%% data X time X motion X people Tensor 구성 완료 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%Tensor Decomposition 시작 %%%%%%%%%%%%%%%%%%%2%%%%%%%%%%

a1 = tenmat(gallery_tensor,1);
eig_1 = eig(a1.data*a1.data');
eig_1 = sort(eig_1,'descend');
sum_eig_1 = sum(eig_1);
part_sum = 0;
for n = 1 : size(a1)
    part_sum = part_sum+eig_1(n);
    if part_sum/sum_eig_1 > 0.99
        rank1 = n;
        break;
    end
end

clear a1; 

a2 = tenmat(gallery_tensor,2);
eig_2 = eig(a2.data*a2.data');
eig_2 = sort(eig_2,'descend');
sum_eig_2 = sum(eig_2);
part_sum = 0;
for n = 1 : size(a2)
    part_sum = part_sum+eig_2(n);
    if part_sum/sum_eig_2 > 0.99
        rank2 = n;
        break;
    end
end

clear a2; 

a3 = tenmat(gallery_tensor,3);
eig_3 = eig(a3.data*a3.data');
eig_3 = sort(eig_3,'descend');
sum_eig_3 = sum(eig_3);
part_sum = 0;
for n = 1 : size(a3)
    part_sum = part_sum+eig_3(n);
    if part_sum/sum_eig_3 > 0.99
        rank3 = n;
        break;
    end
end

clear a3;


T = tucker_als(gallery_tensor,[rank1 rank2 rank3 ]);

Core = ttm(T.core,T.U{1},1);

%% decomposition 끝 사람 벡터 추출 시작

test_motion_selection = [1:28];
test_people = 8;
ppp=5;
thenum=3;


test_motion_frame = [];
for motion = 1 : length(test_motion_selection)
    test_motion_frame = vertcat(test_motion_frame,(test_motion_selection(motion)*100-99:test_motion_selection(motion)*100)');
end

Test = gallery_tensor2(:,test_motion_frame,test_people);

motion_Core2 = ttm(Core,T.U{2}(test_motion_frame,:),2);
        
error = zeros(ppp,1);
for people_index = 1 : ppp    
    real_motion = gallery_tensor2(:,test_motion_frame,people_index);
    real_motion = ttm(motion_Core2,T.U{3}(people_index,:),3);
    error(people_index) = sum(sum(abs(real_motion.data-Test.data)));
end
error;
error_index=[];
for j=1:ppp
[value i] = min(error);
error(i) = 1000000000000000;
error_index(j) = i;
end

people_feature2 = zeros(1,ppp);

temp_z = zeros(ppp,1);

for j=1:ppp
x0 = 0;
obj = @(x)[sum(sum(abs(Test.data-double(ttm(motion_Core2,[x(1)*T.U{3}(error_index(j),:)+people_feature2],3)))))];
options=optimset('LargeScale','off');
[x,fval,exitflag,output]=fminsearch(obj,x0,options)
z = x
temp_z(error_index(j)) = z;
people_feature2 = people_feature2 + z*T.U{3}(error_index(j),:);
end
people_feature2
temp_z

people_feature = people_feature2
% people_feature = people_feature2
% people_feature = people_feature2

recon_motion_tensor = []; 
motion_feature_tensor = [];

for test_motion = 1 : 28
     motion = gallery_tensor2(:,test_motion*100-99:test_motion*100,test_people);
     motion = tensor(motion);
     unfolding_motion = tenmat(motion,1,'t');
     motion_Core = ttm(Core,people_feature,3);
%      motion_Core2 = ttm(motion_Core,T.U{2},2);
%      [u s v] = svd(motion_Core2.data);
%      basis = u(:,1:3);
     unfolding_motion_Core = tenmat(motion_Core,[2]);
     [u s v] = svd(unfolding_motion_Core.data');
     basis = u(:,1:thenum);
     motion_feature = unfolding_motion.data * basis; 
     motion_feature_tensor = vertcat(motion_feature_tensor,motion_feature);
     recon_motion_tensor = horzcat(recon_motion_tensor,(motion_feature* basis')');
end

%% PCA 시작


test_motion_selection = [1:28];


test_motion_frame = [];
for motion = 1 : length(test_motion_selection)
    test_motion_frame = vertcat(test_motion_frame,(test_motion_selection(motion)*100-99:test_motion_selection(motion)*100)');
end

pca_input = tenmat(gallery_tensor,[1]);
 [signal PC v mn] = pca1(pca_input.data);
 
PC = PC(:,1:thenum);

recon_motion_pca = [];
for test_motion = 1:28
     motion = gallery_tensor2(:,test_motion*100-99:test_motion*100,test_people);
     motion = tensor(motion);
     coeff = PC'*(motion.data);
     recon_pca = PC*coeff;
     recon_motion_pca = horzcat(recon_motion_pca,recon_pca);
end
%%

test_motion_selection = [1:28];
test_people = 8;

test_motion_frame = [];
for motion = 1 : length(test_motion_selection)
    test_motion_frame = vertcat(test_motion_frame,(test_motion_selection(motion)*100-99:test_motion_selection(motion)*100)');
end

pca_input = tenmat(gallery_tensor,[1]);
%  pca_input = horzcat(pca_input.data,Test.data);
[mappedX mapping] = compute_mapping(pca_input','PCA',3);
PC = mapping.M;

recon_motion_pca = [];
for test_motion = 1:28
     motion = gallery_tensor2(:,test_motion*100-99:test_motion*100,test_people);
     motion = tensor(motion);
     coeff = PC'*(motion.data-repmat(mapping.mean',1,100));
     recon_pca = reconstruct_data(coeff',mapping); 
%      recon_pca = PC*coeff+repmat(mapping.mean',1,100);
     recon_motion_pca = horzcat(recon_motion_pca,recon_pca');
end
%%

test_motion_selection = [1:28];


test_motion_frame = [];
for motion = 1 : length(test_motion_selection)
    test_motion_frame = vertcat(test_motion_frame,(test_motion_selection(motion)*100-99:test_motion_selection(motion)*100)');
end

pca_input = tenmat(gallery_tensor,[1]);
%  pca_input = horzcat(pca_input.data,Test.data);
[lambda,veig,scores]=robpca(pca_input.data',3,@mad);
% [mappedX mapping] = compute_mapping(pca_input','PCA',3);
PC = veig;

recon_motion_pca2 = [];
for test_motion = 1:28
     motion = gallery_tensor2(:,test_motion*100-99:test_motion*100,test_people);
     motion = tensor(motion);
     coeff = PC'*(motion.data);
%      recon_pca = reconstruct_data(coeff',mapping); 
     recon_pca = PC*coeff;
     recon_motion_pca2 = horzcat(recon_motion_pca2,recon_pca);
end

%% validation
test_motion_selection = [1:28];


test_motion_frame = [];
for motion = 1 : length(test_motion_selection)
    test_motion_frame = vertcat(test_motion_frame,(test_motion_selection(motion)*100-99:test_motion_selection(motion)*100)');
end

real_motion = gallery_tensor2(:,test_motion_frame,test_people);

%%%tensor error량
    error_tensor = (real_motion.data-recon_motion_tensor);
    error_pca = (real_motion.data-recon_motion_pca);
    sum(sum(abs(error_tensor)))-sum(sum(abs(error_pca)))
    error_pca2 = (real_motion.data-recon_motion_pca2);
    sum(sum(abs(error_tensor)))-sum(sum(abs(error_pca2)))