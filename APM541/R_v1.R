#define parameters
N=1000
betalist=c(0.5,1,2,5,10,20) # try different beta values and simulate the growth curve
T=5 #simulate until time T
outcome<-matrix(NA,ncol=length(betalist),nrow=T)
out<-NA
for (j in 1:length(betalist))
{
beta=betalist[j]
t=0
count=1
sites=rep(0,N)
for ( m in 1:10)
{
sites[m]=1
}
a<-c(beta,t,sum(sites))
out<-rbind(out,a)
while (N<10000)
{
u=runif(1,0,1)
lambda=(beta+1)*N
t=t-log(u)/lambda # the next update time
if(t>T){break}
i=sample(1:N,1)
 # choose a site at random
if (sites[i]==1)
{
u=runif(1,0,1)
u=u*(beta+1)
if(u<1)  # individual at sites[i] die
{
sites[i]=0
}
else
{
i=sample(1:N,1)
if(sites[i]==0) # choose another site and give birth if empty
{
sites[i]=1
}
}
}
a<-c(beta,t,sum(sites))
out<-rbind(out,a)
}
}
write.table(out,file="J:\\out.txt",quote=FALSE,row.names=FALSE,col.name=FALSE)
