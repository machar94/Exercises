#include <iostream>
#include <vector>

int getNthUglyNumber(int n);
bool isUglyNumberRecursion(int num);
bool isUglyNumberDynamic(int num, std::vector<bool> &history);

int main(int argc, char* argv[])
{
    int n = 0;

    std::cout << "Input  : n = ";
    std::cin >> n;

    std::cout << "Output : " << getNthUglyNumber(n) << std::endl;

    return 0;
}

int getNthUglyNumber(int n)
{
    if (n == 1)
        return n;

    std::vector<bool> history(1,true); 

    int numUglyNumbers = 1; // Number of ugly numbers encountered
    int num = 2;            // Current number


    while (numUglyNumbers < n)
    {
        // Check if current number is ugly and update number of encountered ugly
        // numbers if so

        /*
        if(isUglyNumberRecursion(num))
        {
            numUglyNumbers++;
        }
        */

        if(isUglyNumberDynamic(num, history))
        {
            numUglyNumbers++;
        }

        num++;
    }

    // num was incremented in while loop 1 extra time
    return num - 1;
}

bool isUglyNumberRecursion(int num)
{
    if (num == 1)
        return true;

    if (num % 2 == 0)
    {
        num /= 2;
        return isUglyNumberRecursion(num);
    }

    if (num % 3 == 0) 
    {
        num /= 3;
        return isUglyNumberRecursion(num);
    }

    if (num % 5 == 0) 
    {
        num /= 5;
        return isUglyNumberRecursion(num);
    }

    return false;
}

bool isUglyNumberDynamic(int num, std::vector<bool> &history)
{
    bool isUgly = false;
    if (num % 2 == 0)
    {
        num /= 2;
        isUgly = history[num-1];
    }
    
    if (num % 3 == 0)
    {
        num /= 3;
        isUgly = history[num-1];
    }

    if (num % 5 == 0)
    {
        num /= 5;
        isUgly = history[num-1];
    }

    history.push_back(isUgly);
    return isUgly;
}