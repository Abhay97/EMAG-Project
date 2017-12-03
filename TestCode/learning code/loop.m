x = 0.01
T01 = x*0.5
T12 = x*1
T23 = x
r = []
Q01 = (1/T01)
Q12 = (1/T12)
Q23 = (1/T23)


while x < 1
    T = Q01*Q12/Q23
    r = [r T]
    
    x = x +.01
end

