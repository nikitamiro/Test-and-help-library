//--------------------------------------------------------------------------------
//Read form file

#include <iostream>
#include <string>
#include <fstream>

int main()
{
    using namespace std;

    ifstream file("file.txt");
    if(file.is_open())
    {
        string myArray[5];

        for(int i = 0; i < 5; ++i)
        {
            file >> myArray[i];
        }
    }

}


//--------------------------------------------------------------------------------
//Default values

int func(int a, int b = 3){
    x = a;
    y = b; 
    return a + b;
}

w = func(4)
z = func(4,5)

//--------------------------------------------------------------------------------
//Pointers  (and references)

int * p = new int;
*p = 7;
int * q = p;
*p = 8;
cout << *q; //prints 8

//References

int a = 5
int & b = a;
b = 7;
cout << a; //prints 7



//--------------------------------------------------------------------------------
//Classes

#include <iostream>
using namespace std;

#define NAME_SIZE 50 // Defines a macro

class Person {
    int id; // all members are private by default
    char name[name_size];

    public:
        void aboutMe(){
            cout << "I am a person.";
        }
        virtual ~Person(){
            cout << "Deleting a person." << endl;
        }
};

class Student : public Person{
    public:
        void aboutMe(){
            cout << "I am a student.";
        }
        ~Student(){
            cout << "Deleting a student." << endl;
        }
};

int main(){
    Student * p = new Student();
    p->aboutMe(); // prints "I am a student."
    delete p; // Important! make sure to delete allocated memory.
    
    Person * q = new Student();
    delete q;  // Prints "Deleting a student."  and  "Deleting a person." 

    return 0;
}