#include <assert.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int move(int cols, int rows, int maxcol) {
    return maxcol * rows + ((cols % maxcol) + 1);
}

int count_trees_part_1(const char* map, int cols, int rows) {
    int count = 0;
    for(int i = 1; i < rows; i++) {
        int pos = move(3 * i, i, cols);
        if (map[pos - 1] == '#') {
            count++;
        }
    }
    return count;
}

int count_trees_part_2(const char* map, int cols, int rows) {
    int count[5] = { 0 };
    int pos = 0;
    int product = 1;

    for(int i = 1; i < rows; i++) {
        // 1 x 1
        pos = move(i, i, cols);
        if (map[pos - 1] == '#') {
            count[0]++;
        }

        // 3 x 1
        pos = move(3 * i, i, cols);
        if (map[pos - 1] == '#') {
            count[1]++;
        }

        // 5 x 1
        pos = move(5 * i, i, cols);
        if (map[pos - 1] == '#') {
            count[2]++;
        }

        // 7 x 1
        pos = move(7 * i, i, cols);
        if (map[pos - 1] == '#') {
            count[3]++;
        }

        // 1 x 2
        pos = move(i, i * 2, cols);
        if (map[pos - 1] == '#') {
            count[4]++;
        }

    }

    for (int i = 0; i < 5; i++){
        product *= count[i];
    }

    return product;
}

char* read_file(const char* src, int* col, int* row) {
    FILE* fp = fopen(src, "r");
    int rows = 0;
    int cols = 0;
    char* buffer = 0;
    int len = 0;

    while (1) {
        char ch = fgetc(fp);
        if (feof(fp)) {
            break;
        }

        if (ch == '\n') {
            rows++;
            if (cols == 0)
            {
                cols = len;
            }
        }
        else {
            len++;
        }
    }

    fseek (fp, 0, SEEK_SET);
    buffer = (char*) malloc(sizeof(char) * len);

    char* temp = buffer;
    while (1) {
        char ch = fgetc(fp);

        if (feof(fp)) {
            break;
        }

        if (ch != '\n') {
            *buffer++ = ch;
        }

    }

    *col = cols;
    *row = rows;
    fclose(fp);

    return temp;
}

int main(int argc, char** argv) {
    if (argc != 2) {
        fprintf(stderr, "file not found\n");
        return -1;
    }

    int cols = 0, rows = 0;
    char* buffer = read_file(argv[1], &cols, &rows);

    assert((int) strlen(buffer) == cols * rows);

    printf("PART 1\n");
    {
        int count = count_trees_part_1(buffer, cols, rows);
        printf("Tree count = %d\n", count);
    }

    printf("PART 2\n");
    {
        int count = count_trees_part_2(buffer, cols, rows);
        printf("Tree count = %d\n", count);
    }

    return 0;
}

