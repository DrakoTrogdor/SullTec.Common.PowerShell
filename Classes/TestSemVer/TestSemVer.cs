using System;

namespace SullTec.Common.PowerShell
{
    public class TestSemVer
    {
        static int Main() {
            bool exit = false;
            do
            {
                Console.Write("Enter a value to test: ");
                string value = Console.ReadLine();
                switch (value)
                {
                    case "q":
                        exit = true;
                        break;
                    default:
                        SemVer test = new SemVer(value);
                        Console.WriteLine(test.ToString());
                        break;
                }
            } while (!exit);
            return 0;
        }
    }
}