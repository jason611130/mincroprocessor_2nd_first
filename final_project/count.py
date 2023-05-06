ss=''
num=315
cnt=0
for i in range(315):
    if(num>200):
        num = 315 -4*i
    elif(num>100):
        num = 315 -3*i
    else:
        num = 315 -2*i
    if(num<0):
        cnt+=1
        num =0
    ss+=str(num)+','
print(ss)
print(cnt)