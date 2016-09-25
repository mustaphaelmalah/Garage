using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using System.Diagnostics;

namespace IPPortScanner
{
    class Program
    {
        static void Main(string[] args)
        {
            int min = 0;
            int max = 253;
            int port = 80;
            string baseIP = "192.168.1.{0}";
            List<string> ipList = new List<string>();

            Console.WriteLine("Checking ip addresses listening on port {0}", port);

            for (int i = min; i <= max; ++i)
            {
                string ip = string.Format(baseIP, i);

                Console.WriteLine("Checking {0}", ip);

                if (IsPortAvailable(ip, port))
                {
                    ipList.Add(ip);
                    Console.WriteLine(" [LISTENING]");
                }
                else
                {
                    Console.WriteLine("[OFFLINE]");
                }
            }

            Console.WriteLine();
            if (ipList.Count == 0)
            {
                Console.WriteLine("No IP addresses has been found listening on port {0}", port);
            }
            else
            {
                Console.WriteLine("{0} addresses has been found listening on port {1}", ipList.Count, port);
                Console.WriteLine("--------------------------");
                foreach (string ip in ipList)
                {
                    Console.WriteLine(ip);
                }
            }

            Console.WriteLine();
            Console.Read();
        }

        public static bool IsPortAvailable(string host, int port, int timeout = 1000)
        {
            bool success = false;
            Socket socket = null;
            try
            {
                socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

                IAsyncResult result = socket.BeginConnect(host, port, null, null);

                success = result.AsyncWaitHandle.WaitOne(timeout, true);

                if (!success)
                {
                    socket.Close();
                    return false;
                }
            }
            catch
            {
                return false;
            }
            finally
            {
                if (socket != null && socket.Connected)
                {
                    socket.Close();
                }
            }

            return success;
        }
    }
}