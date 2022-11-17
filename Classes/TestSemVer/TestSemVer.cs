using System;
namespace SullTec.Common.PowerShell
{
    public class TestSemVer
    {
        static int Main() {
            bool exit = false;
            do
            {
                Console.Write("Enter a value to test (q to quit): ");
                string value = Console.ReadLine();
                switch (value)
                {
                    case "q":
                        exit = true;
                        break;
                    default:
                        try
                        {
                            SemVer test = new SemVer(value);
                            Console.WriteLine(test.ToString());
                            Console.WriteLine("    Major Version:  " + test.Major);
                            Console.WriteLine("    Minor Version:  " + test.Minor);
                            Console.WriteLine("    Patch Version:  " + test.Patch);
                            if (test.HasPreRelease() == true) {
                                Console.WriteLine("    Pre-Release:    " + test.PreRelease);
                            }
                            if (test.HasBuildMetadata() == true) {
                                Console.WriteLine("    Build Metadata: " + test.BuildMetadata);
                            }
                        }
                        catch (System.Exception ex)
                        {
                             Console.WriteLine("Invalid SemVer: " + ex.Message);
                        }
                        break;
                }
            } while (!exit);
            return 0;
        }
    }
}