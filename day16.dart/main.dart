import 'dart:io';

void main() async {
    File file = new File('sample.txt');
    String contents = await file.readAsString();


    List<String> values = contents.trim().split("\n\n");

    RegExp rulesRegExp = RegExp(r"(.*): (\d+)-(\d+) \w+ (\d+)-(\d+)");

    Map<String, Set<int>> rules = new Map();
    List<int> nearByTickets = new List();
    List<int> yourTickets;

    for (String i in values[0].split('\n')) {
        for (var y in rulesRegExp.allMatches(i)) {
            String attribute = y.group(1);
            print(attribute);
            int start1
            // int start = int.parse(y.group(1));
            // int end = int.parse(y.group(2));
            // for (int j = start; j <= end; j++) {
            //     rules.add(j);
            // }
        }
    }

    // yourTickets = values[1]
    //         .split("\n")
    //         .skip(1)
    //         .elementAt(0)
    //         .split(",")
    //         .map((val) { return int.parse(val); })
    //         .toList()
    //         ;

    // var colCount = values[2]
    //         .split("\n")
    //         .skip(1)
    //         .elementAt(0)
    //         .split(",")
    //         .length;

    // for (var i in values[2].split("\n").skip(1)) {
    //     List<int> ticketRow = i
    //             .split(",")
    //             .map((val) { return int.parse(val); })
    //             .toList();
    //     nearByTickets += ticketRow;
    // }

    // int sum = 0;
    // List<int> indicesToBeRemove = new List();
    // for (int i in nearByTickets) {
    //     if (!rules.contains(i)) {
    //         sum += i;
    //         indicesToBeRemove.add(i);
    //     }
    // }

    // for(int i in indicesToBeRemove) {
    //     nearByTickets.remove(i);
    // }

    // print(sum);

    // print(colCount);
    // print(nearByTickets.length / colCount);
}
