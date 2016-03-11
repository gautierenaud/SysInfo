#ifndef _TABLE_LABELS_
#define _TABLE_LABELS_

#define LABEL_CAPACITY 200 

typedef struct{
    int **labels;
    int size;
    int capacity;
}tableLabels;

void initLabelTable(tableLabels **table);
void freeLabelTable(tableLabels **table);
void resizeLabelTable(tableLabels *table);
void printLabelTable(tableLabels *table);

// add method for if jumps
int addLabel1(tableLabels *table, int from);
// to update the destination after the if
void updateLabel(tableLabels *table, int index, int to);
// add method for other jumps
int addLabel2(tableLabels *table, int from, int to);

#endif
