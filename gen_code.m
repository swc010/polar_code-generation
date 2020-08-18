x=[1 0;1 1];
y=[1 0;1 1];
%% 初始化所需参数
N=8;
M=4;%将4位信息生成至8位polar码。
Rn=eye(N);
z_temp=eye(N);
%% 生成预转置矩阵Rn
for i=1:N
    if mod(i,2)==1
        Rn(floor(i/2)+1,:)=z_temp(i,:);
    else
        Rn(floor(i/2)+(N/2),:)=z_temp(i,:);
    end
end
%% 生成克罗内克多次后的G矩阵
for i=1:log2(N)-1
    y=kron(x,y);
end
G=y;
%% 生成比特转置矩阵Bn
B=zeros(1,N);
for i=0:N-1
    B(1,i+1)=fanxu_dec(i,log2(N))+1;
end
Bn_temp=eye(N);
Bn=zeros(N);
for i=1:N
    Bn(i,:)=Bn_temp(B(1,i),:);
end
%% 等效极化矩阵W
W=Bn*G;
%% 开始生成树枝节点
Z=0.5;
for i = 1:log2(N)
    Z_temp = zeros(1,2^i);
    for k = 1:(2^(i-1))
        Z_temp(2*k-1)=2*Z(1,k)-(Z(1,k))^2;
        Z_temp(2*k)=(Z(1,k))^2;
    end
    Z=Z_temp;
end
%% 确定信道极化矩阵里面，选择哪几行当做生成矩阵的行，找的是信号损耗最小的那几个。
index = sort(find_n_mini(Z_temp,M));
code_gen = zeros(M,N);
for i = 1:M
    code_gen(i,:)=W(index(1,i),:);
end
code_gen
%% 找到前n小的一个小函数（目前正在学着咋优化，例如不用他的库函数，dalao轻喷！！！！）
function y=find_n_mini(list,n)
index = zeros(1,n);
    for i = 1:n
        [~,index(1,i)] = min(list);
        list(1,index(1,i))=1;
    end
y=index;
end
%% 一个反序函数，指定字长的
function y=fanxu_dec(x,N)
    if x>2^N
        disp("sucker");
    else
        y=zeros(1,N);
        i=N;
        while(x~=0)
            y(1,i) = mod(x,2);
            x=floor(x/2);
            i=i-1;
        end
%         y=fliplr(y);
        y
        res=0;
        for i = 1:N
            if y(1,i)==1
                res=res+2^(i-1);
            end
        end
        y=res;
    end
end
