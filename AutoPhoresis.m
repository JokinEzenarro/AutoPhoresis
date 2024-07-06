%% ANALYSIS
im=imread('gel-image.jpeg');
a=figure;imshow(im)
mask = roipoly;
close(a)
%%
xM=sum(mask,1);
yM=sum(mask,2);
temp = find(xM);
x1 = temp(1);
x2 = temp(end);
temp = find(yM);
y1 = temp(1);
y2 = temp(end);
im_crop = im(y1:y2,x1:x2);

dist=mean(im_crop,1);
figure,plot(diff(dist))
%th = input('Background treshold: ');
th = std(diff(dist));
hold on, yline(th,'r'), yline(-th,'r')

add=abs(diff(dist));
lim=find(add>th);
n=1;
limt(n)=lim(1);
for i=1:size(lim,2)-1
    if lim(i)+1==lim(i+1)
    else
        limt(n)=lim(i);
        n=n+1;
    end
end
[~,lims(1)]=max(add(1:limt(1)));
for i=1:size(limt,2)-1
    [~,n]=max(add(limt(i)+1:limt(i+1)));
    lims(i+1)=n+limt(i);
end
[~,n]=max(add(limt(i+1):end));
lims(i+2)=n+limt(i+1);

lim1=lims(1:2:end);
lim2=lims(2:2:end);

lim1m=NaN(size(im_crop,1),size(im_crop,2));
lim1m(:,lims)=1;
lim1m(:,lims+1)=1;
figure,imshow(im_crop)
hold on
surf(lim1m,'edgecolor','none')
for i=1:size(lim1,2)
    text(lim1(i)+5,20,string(i),'Color','white','FontWeight','bold','FontSize',15);
end
%%
for i=1:size(lim1,2)
    av(i,:)=mean(im_crop(:,lim1(i):lim2(i)),2);
end
figure,plot(av')
%%
av_diff=diff(av');
figure,plot(av_diff)
f = fit(x.',y.','gauss2');
