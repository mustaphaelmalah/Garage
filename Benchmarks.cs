using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace Benchmarks
{
    class Program
    {
        static void Main(string[] args)
        {
            TimeConversion();
        }

        //============================
        public static int ToInt(object obj)
        {
            if (obj == null || obj == DBNull.Value)
            {
                return default(int);
            }
            else
            {
                if (obj is int)
                {
                    return (int)obj;
                }
                else
                {
                    int result;
                    int.TryParse(obj.ToString(), out result);
                    return result;
                }
            }
        }

        public static int ToInt2(object obj)
        {
            if (obj == null || obj == DBNull.Value)
            {
                return 0;
            }
            else
            {
                int result = 0;
                int.TryParse(obj.ToString(), out result);
                return result;
            }
        }

        public static void TimeConversion()
        {
            int count = 10000; // 10000 entries by a user

            Stopwatch sw = new Stopwatch();
            TimeSpan t1, t2;

            // Fill test data
            List<object> ints = new List<object>();
            List<object> ints_out = new List<object>();
            for (int i = 0; i < count; ++i)
                ints.Add(i);

            List<object> strings = new List<object>();
            List<object> strings_out = new List<object>();
            for (int i = 0; i < count; ++i)
            {
                strings.Add(i.ToString());
            }

            // Start timing
            sw.Start();
            for (int i = 0; i < ints.Count; ++i)
            {
                ints_out.Add(ToInt(ints[i]));
            }
            sw.Stop();
            t1 = sw.Elapsed;

            sw.Reset();

            sw.Start();
            for (int i = 0; i < strings.Count; ++i)
            {
                strings_out.Add(ToInt(strings[i]));
            }
            sw.Stop();
            t2 = sw.Elapsed;

            Console.WriteLine("CastWhenPossible: {0}", t1);
            Console.WriteLine("AlwaysParse: {0}", t2);
        }
        //============================
        private static TimeSpan TimeTypeCheck(double errorRate, double strRate, int seed, int count)
        {
            Stopwatch sw = new Stopwatch();
            Random random = new Random(seed);
            string bad_prefix = @"X";

            sw.Start();

            for(int ii = 0; ii < count; ++ii)
            {
                object input;
                double nextDouble = random.NextDouble();

                if(nextDouble < strRate)
                {
                    input = random.Next().ToString();

                    if(nextDouble < errorRate)
                    {
                        input = bad_prefix + input.ToString();
                    }
                }else
                {
                    input = random.Next();
                }

                int value = 0;
                if(input is int)
                {
                    value = (int)input;
                }else
                {
                    if(!int.TryParse(input.ToString(), out value))
                    {
                        value = -1;
                    }
                }
            }
            sw.Stop();

            return sw.Elapsed;
        }

        public static void TimeTypeChecksVsTryParse()
        {
            double errorRate = 0.1; // 10% of the time our users mess up
            double parseRate = 0.5; // 50% tryparse
            int count = 10000; // 10000 entries by a user

            TimeSpan _as = TimeTypeCheck(errorRate, parseRate, 1, count);
            TimeSpan tryparse = TimeTryParse(errorRate, 1, count);

            Console.WriteLine("as: {0}", _as);
            Console.WriteLine("tryparse: {0}", tryparse);
        }

        //============================
        /// <param name="errorRate">Rate of errors in user input</param>
        /// <returns>Total time taken</returns>
        public static TimeSpan TimeTryCatch(double errorRate, int seed, int count)
        {
            Stopwatch stopwatch = new Stopwatch();
            Random random = new Random(seed);
            string bad_prefix = @"X";

            stopwatch.Start();
            for (int ii = 0; ii < count; ++ii)
            {
                string input = random.Next().ToString();
                if (random.NextDouble() < errorRate)
                {
                    input = bad_prefix + input;
                }

                int value = 0;
                try
                {
                    value = Int32.Parse(input);
                }
                catch (FormatException)
                {
                    value = -1; // we would do something here with a logger perhaps
                }
            }
            stopwatch.Stop();

            return stopwatch.Elapsed;
        }

        /// <param name="errorRate">Rate of errors in user input</param>
        /// <returns>Total time taken</returns>
        public static TimeSpan TimeTryParse(double errorRate, int seed, int count)
        {
            Stopwatch stopwatch = new Stopwatch();
            Random random = new Random(seed);
            string bad_prefix = @"X";

            stopwatch.Start();
            for (int ii = 0; ii < count; ++ii)
            {
                string input = random.Next().ToString();
                if (random.NextDouble() < errorRate)
                {
                    input = bad_prefix + input;
                }

                int value = 0;
                if (!Int32.TryParse(input, out value))
                {
                    value = -1; // we would do something here with a logger perhaps
                }
            }
            stopwatch.Stop();

            return stopwatch.Elapsed;
        }

        public static void TimeStringParse()
        {
            double errorRate = 0.1; // 10% of the time our users mess up
            int count = 10000; // 10000 entries by a user

            TimeSpan trycatch = TimeTryCatch(errorRate, 1, count);
            TimeSpan tryparse = TimeTryParse(errorRate, 1, count);

            Console.WriteLine("trycatch: {0}", trycatch);
            Console.WriteLine("tryparse: {0}", tryparse);
        }
    }
}
