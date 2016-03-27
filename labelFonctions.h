#ifndef _TABLE_LABELS_
#define _TABLE_LABELS_

#define LABEL_CAPACITY 200 

typedef struct{
    int *from;
		char **to;
    int size;
    int capacity;
}tableLabelFonctions;

void initLabelTableFonctions(tableLabelFonctions **table);
void freeLabelTableFonctions(tableLabelFonctions **table);
void printLabelTableFonctions(tableLabelFonctions *table);

// to update the destination after the if
void updateLabelFonctions(tableLabelFonctions *table, int index, char* to);
// add method for other jumps
int addLabelFonctions2(tableLabelFonctions *table, int from, char* to);

#endif
