function randP = GenRandPtuoyuan3(BnodeI,n,suijidiangeshu,treedata,year)

sizeB = size(BnodeI);


suijidiangeshu =  suijidiangeshu - year*4; %ÿ�������ɵĵ��Ƹ�������ݼ�

if sizeB(2) * suijidiangeshu >20000 %Ϊ��֤�ٶȣ����������಻����20000��
    suijidiangeshu = round(20000/sizeB(2));
end

randP = zeros(suijidiangeshu*sizeB(2),3);
point_temp = 1;

for mm = 1 : sizeB(2)
        node = treedata(BnodeI(1,(mm)),1:3);
        Odirection = node - treedata(BnodeI(1,(mm))-1,1:3);
        l = BnodeI(2,(mm)) / floor(BnodeI(2,(mm)))/10;
        t1 = rand(1,suijidiangeshu)*2*pi;
        t2 = rand(1,suijidiangeshu)*pi;
        ll = rand(1,suijidiangeshu)*n*l;
        x = ll .* sin(t2).* cos(t1) + node(1);
        y = ll .* sin(t2).* sin(t1) + node(2);
        z = ll .* cos(t2) + node(3);
        temp = [x' y' z'];
        max = suijidiangeshu ;
        k = 1;
        while 1
            if k > max
                break
            end
            Direction = temp(k,:) - node;
            jiaodu = sum(Odirection .* Direction)/(norm(Odirection)*norm(Direction));
            jiaodu = acos(jiaodu)*180/pi;
            if norm(node-temp(k,:)) <= 2 * l  || jiaodu >= 90 
                temp(k,:) = [];
                k = k-1;
                max = max -1;
            end
            k = k+1;
        end
        
        randP(point_temp:point_temp + k-2,:) = temp;
        point_temp = point_temp + k-1;
end

randP(point_temp:end,:) = [];
randP = KDTreeSearcher(randP);

