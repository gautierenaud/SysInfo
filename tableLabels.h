#ifndef _TABLE_LABELS_
#define _TABLE_LABELS_

#define CAPACITY 300

typedef struct{
    char name[256];
    int line;
}label;

typedef struct{
    label *l;
    int size;
    int capacity;
}tableLabel;


int containsLabel(tableLabel *table, char name[256]);
void addLabel(tableLabel *table, label l);
void addLabel2(tableLabel *table, char name[256], int line);
void freeLabelTable(tableLabel *table);

#endif
