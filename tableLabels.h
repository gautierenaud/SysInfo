#ifndef _TABLE_LABELS_
#define _TABLE_LABELS_

#define LABEL_CAPACITY 200 

typedef struct{
    int labels[LABEL_CAPACITY][2];
    int size;
    int capacity;
}tableLabels;

void initLabelTable(tableLabels *table);
void freeLabelTable(tableLabels *table);
void resizeLabelTable(tableLabels *table);
void printLabelTable(tableLabels *table);

#endif
