function [level, year,  BranchNo, NodeNo, jishuge, Ltheta, treedata, I,BnodeI,quchuP1,randP] = GenTree8(root,level,NodeNum,...
   radius,length,theta,phy,year,BranchNo,NodeNo,RootNo,jishuge,yuanzhi,Ltheta,treedata,I,BnodeI,j,shuzhi,randP,NNN)
    
    %��ʼ�ڵ�ļ�¼
    BranchNo = BranchNo + 1;
    Mnodes = zeros(NodeNum,5);
    Mnodes(1,1:3) = root ;
    Mnodes(1,4) = radius;
    Mnodes(1,5) = RootNo;
    MNodeNo = NodeNo;
    quchuP1 = [];
    %
    for i = 1:NodeNum-1
        %% �������֦�������Լ�������Ϣ����
        if i==1
            jishux = floor(Mnodes(1,1) * 20) + 81;
            jishuy = floor(Mnodes(1,2) * 20) + 81;
            jishuz = floor(Mnodes(1,3) * 20) + 21;
            jishuge(jishux,jishuy,jishuz) = jishuge(jishux,jishuy,jishuz) + 1;
            [theta,~,nodex,nodey,nodez,NodeNum,test2,randP,quchuP] = nextnode3(Mnodes,i,length,theta,phy,level,NodeNum,jishuge,year,randP,NNN); %���ݵ���ȷ������������
            jishuge(jishux,jishuy,jishuz) = jishuge(jishux,jishuy,jishuz) - 1;
        else
            [theta,~,nodex,nodey,nodez,NodeNum,test2,randP,quchuP] = nextnode3(Mnodes,i,length,theta,phy,level,NodeNum,jishuge,year,randP,NNN);
            
        end
        quchuP1 = [quchuP1 quchuP];
        if test2 == 0
            break
        end
       
        [NodeNum, jishuge, test] = Qjishu(i,NodeNum,nodex,nodey,nodez,jishuge); %����µ��Ƿ����й�ռ� 
      
        if test == 0
            break
        end
        MNodeNo = MNodeNo + 1;
        Mnodes(i+1,:) = [nodex nodey nodez radius MNodeNo];
        direction2 = Mnodes(i+1,1:3) - Mnodes(i,1:3);
        direction2 = direction2/norm(direction2);
        phy = subspace([0 0 1]',direction2');
        if direction2(3) < 0
            phy = pi -  phy;
        end
  end
    
    %% ���������ɵ�����Ի����Ĺ���Ϣ���и���
    sizeM = size(Mnodes);
    Mnodes(NodeNum+1:sizeM(1),:) = [];
    for i =2 : NodeNum 
        nodex =Mnodes(i,1);
        nodey =Mnodes(i,2);
        nodez =Mnodes(i,3);
        jishuge = Qjishu2(nodex,nodey,nodez,jishuge,year,NNN);
    end
    %% ����֦�ɻ����Ƚ�Ư�� �����Ż��޸ģ�
    if NodeNum < 2 && level == 2
         Ltheta = Ltheta - 135/180*pi;
        return
    elseif NodeNum < 2
        return
    end
    
    %% ��������֦���������洢���� ������ǽ���ԭ֦��������������������ݲ��뵽����֦���ݵĺ��棬�����������֦�������ݴ�������������ĩ�˴��룩
   
    temp = [Mnodes(1,1:4) level year RootNo 1];
    for i =1:NodeNum-1
        NodeNo = NodeNo + 1;
        temp = [temp;Mnodes(i+1,1),Mnodes(i+1,2),Mnodes(i+1,3),Mnodes(i+1,4),level,year,NodeNo,i+1];
    end
    
    sizet = size(treedata);
    sizei = size(I);
    if yuanzhi ==1
        temp(1,:) = [];
        temp(:,8) = temp(:,8) + I(2*shuzhi)-1;
        treedata(I(2*shuzhi)+1:sizet(1),8) = treedata(I(2*shuzhi)+1:sizet(1),8) + NodeNum -1;
        treedata = [treedata(1:I(2*shuzhi),:);temp;treedata(I(2*shuzhi)+1:sizet(1),:)];
        I(2*shuzhi:sizei(2)) = I(2*shuzhi:sizei(2)) + NodeNum -1; 
        sizeb = size(BnodeI);
        BnodeI(1,j+1:sizeb(2)) = BnodeI(1,j+1:sizeb(2)) + NodeNum - 1;
    else
        temp(:,8) = temp(:,8) + sizet(1);
        treedata = [treedata;temp;[0 0 0 0 0 0 0 0]];
        I = [I sizet(1)+1 sizet(1)+NodeNum];
        
    end