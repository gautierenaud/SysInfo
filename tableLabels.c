#include "tableLabels.h"
#include <stdio.h>
#include <stdlib.h>

void initLabelTable(tableLabels *table){
    table->size = 0;
    table->capacity = LABEL_CAPACITY;
    table->labels = malloc(sizeof(int*) * table->capacity);
}

void resizeLabelTable(tableLabels *table){
    table->capacity *= 2;
    table->labels = (int**) realloc(table->labels, table->capacity * sizeof(*table->labels));   
}

void freeLabelTable(tableLabels *table){
    int i;
    for (i = 0; i < table->size; i++){
        free(table->labels[i]);
    }
    free(table->labels);
    free(table);
}

void printLabelTable(tableLabels *table){
    printf("size of label table: %d; capacity: %d\n", table->size, table->capacity);
    int i;
    for (i = 0; i < table->size; i++){
        printf("\tfrom: %d; to: %d\n", table->labels[i][0], table->labels[i][1]);
    }
}

int addLabel1(tableLabels *table, int from){
    if (table->size == table->capacity)
        resizeLabelTable(table);
    table->labels[table->size] = malloc(sizeof(int) * 2);
    table->labels[table->size][0] = from;
    table->labels[table->size][1] = -1;
    return table->size++;
}

int addLabel2(tableLabels *table, int from, int to){
    if (table->size == table->capacity)
        resizeLabelTable(table);
    table->labels[table->size] = malloc(sizeof(int) * 2);
    table->labels[table->size][0] = from;
    table->labels[table->size][1] = to;
    return table->size++;
}

void updateLabel(tableLabels *table, int index, int to){
    table->labels[index][1] = to;
}
