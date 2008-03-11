%%% this script is meant to watch a series of frames and track the
%%% position of the base of the largest barrel in order to try to figure out
%%% the way barrel shape changes with position. It should be fed data where
%%% there is an unobscured lone barrel to track which has the lowest point
%%% of its base and the highest point of its top still in the frame.

%%this is a variant of blackbarrels


clear
xsiz=[];
ysiz=[];
ratxy=[];
for number=5:144
% for number=[1:4 22 25 29 30 44 45 83 86 87 90 91 95 100:103 108 118 119 131:134]
%for number=[11]
close all
clc
%clear ~(n*)
testin='/home/robo/Desktop/Home/IGVC 2007 Video Capture/barrel fly stills/barfly_000138.bmp';
fr1 = double(imread(['i/' num2str(number)]))./255;
%fr1 = double(imread(testin))./255;
fr1=fr1(1:4:end,1:2:end,:);
fr1(:,:,1)=medfilt2(fr1(:,:,1),[3,3]);
fr1(:,:,2)=medfilt2(fr1(:,:,2),[3,3]);
fr1(:,:,3)=medfilt2(fr1(:,:,3),[3,3]);

%imshow(bw1)
%fr1(:,:,3)=fr1(:,:,3).*(.8+fr1(:,:,3)*.2);
r=fr1(:,:,1);
g=fr1(:,:,2);
b=fr1(:,:,3);


frh=rgb2hsv(fr1);
h=(1-frh(:,:,1)).*frh(:,:,2);
frf=frh;
frf(:,:,3)=(frf(:,:,3)*0+.5).*(frf(:,:,3)>.09);
frf=hsv2rgb(frf.*trip(frf(:,:,3)>.09));





%find by greend
orn=r-g;
%%super good greedy red
isg2l=(and((orn>0.05),(g>30/255)));
%%bright reluctant
isgl3=(orn>0.2) & (g>30/255);

%Dark Reluctant
%orn>3/255,fr1.r<120,fr.r>30
isgl=(orn>10/255) & (r<130/255) & (r>50/255) & (g<65/255);
isgl2=isgl & (g>50/255);
%VeryDark semi-reluctant 
isgl=(orn>7/255) & (r<130/255) & (r>47/255) & (g<45/255);
isgl=isgl & (b<45/255);
isgl=isgl|isgl2|isgl3;
idg=light(fr1,isgl);



%find by blue
orn=r-b;
isbl=(orn>.3) & (g>30/255);
idb=fr1.*trip(isbl)+fr1*.2;

%whitish?
bgl=(b./g)>.7 & b>.4 &(g./(r+b))<.6;
% bgl=bgl|frh(:,:,3)>.5&frh(:,:,2)./(1-frh(:,:,3))<1.;
% bgl=bgl&abs(frh(:,:,1)-.39)>.1;
bg=light(fr1,bgl);
%figure,imshow(max(min(or,1),0))
%figure, imshow(imfill(bw2,'holes'))

whitenotred=(bgl & ~isgl);


bar=light(fr1,isgl|bgl);




%grasscomponent
gc=gcomp(frf);
%normalize


%barrelcomponent
bc=bcomp(frf);

%normalize
%dis=medfilt2(clm(bc-gc),[5,5]);
dis=clm(bc-gc);

% vslip=fr1.*0;
% vslip(4:end,:,1)=clm(-dis(1:end-3,:)-dis(2:end-2,:)+dis(3:end-1,:)+dis(4:end,:));
% vslip(4:end,:,2)=clm(-(-dis(1:end-3,:)-dis(2:end-2,:)+dis(3:end-1,:)+dis(4:end,:)));
% vslip2=vslip(1:end-2,:).*vslip(2:end-1,:).*vslip(3:end,:)*100;


figure,imshow(frf)
figure,image(fr1)
%  figure,imshow(bg)
%  figure,imshow(isg2l)
%  figure,imshow(gc*2)
%figure,imshow(light(fr1,r-g>.1))
% figure,imshow(dis*2)
% figure,imshow(dis>.1)
%figure,imshow(light(fr1,isgl|bgl|r-g>.02))
% figure,imshow(vslip*4)
%figure,imshow(bcomp(frf))
%figure

warning off
orim=dis>.1|r-g>.1;
whim=isgl|bgl|r-g>.02;
cdown=curtain(orim,whim);
cup=curtain(orim(end:-1:1,:),whim(end:-1:1,:));
cup=cup(end:-1:1,:);
splot=(cdown&cup);
splot=imopen(splot,strel('rectangle',[1,1]));
blacked=fr1.*~trip(splot);
figure,imshow(orim)
%figure
%imshow(blacked)
%imwrite(blacked,'out.bmp','bmp')
%figure,imshow(vslip(:,:,1)>.1|vslip(:,:,2)>.1)

% figure
% imshow(light(fr1,r>g&r<180))
%imshow(fr1)
title(['i/' num2str(number)])

figure,image(blacked)
axis tight
hold on
[x,y]=bighull(splot);
plot(x,y,'r','LineWidth',2)
hold off
xsiz=[xsiz;max(x)-min(x)];
ysiz=[ysiz;max(y)-min(y)];
ratxy=[ratxy;(max(y)-min(y))/(max(x)-min(x))];
% r=r.^.05;
% g=g.^.05;
% b=b.^.05;
%% (b/r)hat=-3.87r^3 + 7.64r^2 - 4.51r + 1.46
%%
%plot(g(:),b(:)./g(:),'.');


% gp=1.5*g./(r+g+b);
% an=light(fr1,gp> .8);
% figure,imshow( an )
% gpm=medfilt2(gp,[10 3]);
% figure,imshow(gp)
% figure,imshow(gpm)

%figure,imshow(light(fr1,whitenotred))


%imshow(oper)
% % medout(:,:,1)=medfilt2(r./(sum(fr1,3)));
% % medout(:,:,2)=medfilt2(g./(sum(fr1,3)));
% % medout(:,:,3)=medfilt2(b./(sum(fr1,3)));
% medout(:,:,1)=rp;
% medout(:,:,2)=gp;
% medout(:,:,3)=bp;
% imshow(medout)
%% Slicing
% hold on
% st=230;
% ed=340;
% h=20;
% plot([st,ed],[h+1,h+1],'r')



%figure, imshow(bar)


% %subplot(2,1,2)
% figure
% cut=fr1(h-1,st:ed,:);
% cd=diff(cut);
% cd2=splitsum(cd);
% 
% cdr=cd(:,end:-1:1,:);
% cd3r=splitsum(cdr);
% cd3=cd3r(:,end:-1:1,:);%+cd2;
% hold on
% 
% st=st+.5;
% ed=ed-.5;
% % plot([st:ed],cd2(:,:,1),'r')
% % plot([st:ed],cd2(:,:,2),'g')
% % plot([st:ed],cd2(:,:,3),'b')
% % plot([st:ed],cd3(:,:,1),'r')
% % plot([st:ed],cd3(:,:,2),'g')
% % plot([st:ed],cd3(:,:,3),'b')
% % axis tight
%%




pause
end