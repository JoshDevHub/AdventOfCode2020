namespace Day1
{
    class Program
    {
        static void Main(string[] args)
        {
            string[] text = System.IO.File.ReadAllLines($"../{args[0]}.txt");
            int[] ints = Array.ConvertAll(text, int.Parse);

            var report = new ExpenseReport(ints);

            var twoSum = report.SumProduct(2); // 691771
            var threeSum = report.SumProduct(3); // 232508760
        }
    }

    class ExpenseReport
    {
        private int[] data;
        private const int target = 2020;

        public ExpenseReport(int[] data)
        {
            this.data = data;
        }

        public int SumProduct(int sumParts)
        {
            var list = sumParts switch
            {
                2 => findTwoSum(),
                3 => findThreeSum(),
                _ => throw new ArgumentException("Invalid method")
            };
            return list.Aggregate(1, (prod, curr) => prod * curr);
        }

        private List<int> findTwoSum()
        {
            var set = new HashSet<int>();
            var sumValues = new List<int> {};

            for (var i = 0; i < data.Length; i++)
            {
                var difference = target - data[i];
                if (set.Contains(difference))
                {
                    sumValues.AddRange(new int[] { difference, data[i] });
                    return sumValues;
                }
                set.Add(data[i]);
            }
            return sumValues;
        }

        private List<int> findThreeSum()
        {
            var sumValues = new List<int> {};

            for (int i = 0; i < data.Length - 2; i++)
            {
                HashSet<int> Set = new HashSet<int>();
                var firstDiff = target - data[i];

                for (int j = i + 1; j < data.Length; j++)
                {
                    var secondDiff = firstDiff - data[j];
                    if (Set.Contains(secondDiff))
                    {
                        sumValues.AddRange(new int[] { secondDiff, data[i], data[j] });
                        return sumValues;
                    }
                    Set.Add(data[j]);
                }
            }
            return sumValues;
        }
    }
}
