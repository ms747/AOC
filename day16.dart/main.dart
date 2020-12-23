import 'dart:io';

class Entry {
    String key;
    List<int> value;

    Entry(String key) {
        this.key = key;
        this.value = new List();
    }

    void add(int value) {
        this.value.add(value);
    }

    @override
    String toString() {
        return "${this.key} - ${this.value}";
    }
}

List<int> getColumn(List<int> nt, List<int> yt, List<int> ig, int at, int id) {
    List<int> temp = new List();

    for (int i = id; i < nt.length; i += at) {
        temp.add(nt[i]);
    }

    if (!temp.contains(yt[id])) {
        temp.add(yt[id]);
    }

    for (int ignore in ig) {
        temp.remove(ignore);
    }

    return temp;
}

void main(List<String> args) async {
    if (args.length < 1) {
        print("input.txt not provided");
        exit(1);
    }

    File file = new File(args[0]);
    String contents = await file.readAsString();

    List<String> values = contents.trim().split("\n\n");
    RegExp rulesRegExp = RegExp(r"(.*): (\d+)-(\d+) \w+ (\d+)-(\d+)");


    Map<String, Set<int>> rules = new Map();
    for (String i in values[0].split('\n')) {
        for (RegExpMatch y in rulesRegExp.allMatches(i)) {
            Set<int> setHolder = {};
            String attribute = y.group(1);

            int start1 = int.parse(y.group(2));
            int end1 = int.parse(y.group(3));
            int start2 = int.parse(y.group(4));
            int end2 = int.parse(y.group(5));

            for (int i = start1; i <= end1; i++) {
                setHolder.add(i);
            }

            for (int i = start2; i <= end2; i++) {
                setHolder.add(i);
            }

            rules[attribute] = setHolder;
        }
    }


    List<int> yourTickets = values[1]
            .split("\n")
            .skip(1)
            .elementAt(0)
            .split(",")
            .map(int.parse)
            .toList();


    List<int> nearByTickets = new List();
    for (String i in values[2].split("\n").skip(1)) {
        List<int> ticketRow = i
                .split(",")
                .map(int.parse)
                .toList();
        nearByTickets += ticketRow;
    }

    Set<int> flatRules = rules
            .entries
            .fold(<int>{}, (acc, item) {
                acc.addAll(item.value); return acc;
            });

    int sum = 0;
    List<int> indicesToBeRemove = new List();
    for (int i in nearByTickets) {
        if (!flatRules.contains(i)) {
            sum += i;
            indicesToBeRemove.add(i);
        }
    }

    print("Part 1 $sum");

    List<Entry> entries = new List();

    for(MapEntry<String, Set<int>> kvp in rules.entries) {
        Entry entry = new Entry(kvp.key);
        for(int i = 0; i < yourTickets.length; i++) {
            List<int> col =
                    getColumn(nearByTickets, yourTickets,
                            indicesToBeRemove, yourTickets.length, i);

            if (kvp.value.containsAll(col)) {
                entry.add(i);
            }
        }
        entries.add(entry);
    }

    entries.sort((a, b) => a.value.length - b.value.length);

    for(int i = 0; i < entries.length; i++) {
        for(int j = i + 1; j < entries.length; j++) {
            List<int> duplicates = entries[i].value;
            for (int duplicate in duplicates) {
                entries[j].value.remove(duplicate);
            }
        }
    }


    int productOfDepartures = entries.fold(1, (acc, item) {
        if (item.key.contains("departure")) {
            acc *= yourTickets[item.value[0]];
        }
        return acc;
    });

    print("Part 2 : $productOfDepartures");
}
