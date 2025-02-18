def add(a, b):
    return a + b

def sub(a, b):
    return a-b

if __name__ == '__main__':
    a = int(input("Enter first number: "))  
    b = int(input("Enter second number: "))

    print(add(a, b))

    print(sub(a, b))