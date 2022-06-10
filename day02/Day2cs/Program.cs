namespace Day2
{
    class Program
    {
        static void Main(string[] args)
        {
            List<string> text = File.ReadAllLines($"../{args[0]}.txt").ToList();
            var passwords = new List<(int, int, char, string)>();

            foreach(var line in text)
            {
                string[] substrings = line.Split(' ');

                int[] range = substrings[0].Split('-').Select(number => Int32.Parse(number)).ToArray();
                char letter = substrings[1][0];
                string password = substrings[2].Trim();

                passwords.Add((range[0], range[1], letter, password));
            }

            var validator = new PasswordValidator(passwords);
            Console.WriteLine(validator.CountValidSledPasswords()); // 636
            Console.WriteLine(validator.CountValidTobogganPasswords()); // 588
        }
    }

    class PasswordValidator
    {
        private List<(int, int, char, string)> Data;

        public PasswordValidator(List<(int, int, char, string)> data)
        {
            Data = data;
        }

        public int CountValidSledPasswords()
        {
            int validCount = Data.Count(segment => {
                (int min, int max, char letter, string password) = segment;
                int letterCount = password.Count(character => character == letter);
                return (letterCount <= max && letterCount >= min);
            });

            return validCount;
        }

        public int CountValidTobogganPasswords()
        {
            int validCount = Data.Count(segment => {
                (int min, int max, char letter, string password) = segment;
                int firstIdx = min - 1;
                int secondIdx = max - 1;
                return (password[firstIdx] == letter) ^ (password[secondIdx] == letter);
            });

            return validCount;
        }
    }
}
