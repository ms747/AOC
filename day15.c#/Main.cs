using System;
using System.Collections.Generic;

class MainClass {
    class NumberInfo {
        public int count;
        public int first;
        public int second;

        public NumberInfo(int count, int first, int second) {
            this.count = count;
            this.first = first;
            this.second = second;
        }

        public void NewPosition(int position) {
            this.count += 1;
            this.first = this.second;
            this.second = position;
        }

        public override string ToString() {
            return
                "Count : " + this.count + " First : " + this.first +
                " Second : " + this.second;
        }

    }

    public static void Main() {
        int[] starting = {0, 3, 1, 6, 7, 5};
        Dictionary<int, NumberInfo> visits = new Dictionary<int, NumberInfo>();
        int lastSpokenNumber = -1;

        for (int i = 1; i <= 30000000 ; i++) {
            if (i <= starting.Length) {
                visits[starting[i - 1]] = new NumberInfo(0, i, i);
                lastSpokenNumber = starting[i - 1];
            } else {
                if (visits.ContainsKey(lastSpokenNumber)) {
                    if (visits[lastSpokenNumber].count == 0) {
                        lastSpokenNumber = 0;
                        if (visits.ContainsKey(lastSpokenNumber)) {
                            visits[lastSpokenNumber].NewPosition(i);
                        } else {
                            visits[lastSpokenNumber] = new NumberInfo(0, i, i);
                        }
                    } else {
                        lastSpokenNumber =
                            visits[lastSpokenNumber].second
                            - visits[lastSpokenNumber].first;

                        if (visits.ContainsKey(lastSpokenNumber)) {
                            visits[lastSpokenNumber].NewPosition(i);
                        } else {
                            visits[lastSpokenNumber] = new NumberInfo(0, i, i);
                        }
                    }
                }
            }
            if (i == 2020) {
                Console.WriteLine("Part 1 : {0}", lastSpokenNumber);
            }
        }
        Console.WriteLine("Part 2 : {0}", lastSpokenNumber);
    }
}
