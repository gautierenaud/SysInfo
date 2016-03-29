#include "labelFonctions.h"
#include <stdio.h>
#include <stdlib.h>

void initLabelTableFonctions(tableLabelFonctions **table){
    *table = malloc(sizeof(tableLabelFonctions));
    (*table)->size = 0;
    (*table)->capacity = LABEL_CAPACITY;
    (*table)->from = malloc(sizeof(int*) * (*table)->capacity);
    (*table)->to = malloc(sizeof(char*) * (*table)->capacity);
}


void freeLabelTableFonctions(tableLabelFonctions **table){
    int i;
    /*
    for (i = 0; i < table->size; i++){
        free(table->labels[i]);
    }*/
    //free(table->labels);
    free((*table)->from);
		free((*table)->to);
    free(*table);
}

void printLabelTableFonctions(tableLabelFonctions *table){
    printf("size of label table: %d; capacity: %d\n", table->size, table->capacity);
    int i;
    for (i = 0; i < table->size; i++){
        printf("\tfrom: %d; to: %s\n", table->from[i], table->to[i]);
    }
}

int addLabelFonctions2(tableLabelFonctions *table, int from, char* to){
    if (table->size == table->capacity)
				exit(-1);
		table->to[table->size] = malloc(sizeof(char*));
    table->from[table->size] = from;
    table->to[table->size] = to;
    return table->size++;
}

void updateLabelFonctions(tableLabelFonctions *table, int index,char* to){
    table->to[index] = to;
}



