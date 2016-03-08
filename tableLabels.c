#include "tableLabels.h"

void initLabelTable(tableLabels *table){
    table->size = 0;
    table->capacity = LABEL_CAPACITY;
}

void resizeInstructionTable(tableLabels *table){
    table->capacity *= 2;
    table->labels = (int**) realloc(table->labels, table->capacity * sizeof(*table->labels));   
}
