#ifndef __SE_API_H__
#define __SE_API_H__

struct seQuestion {
  int id;
  int score;
  int answers;
  int views;
  int last_activity_date;
  char *title;
  char *link;
};

void se_print_question(struct seQuestion *q);
struct seQuestion *se_new_question(int id, int score, int answers,
  int views, int last_activity_date, const char *title, const char *link);
void se_free_question(struct seQuestion *q);
void se_free_questions(struct seQuestion **qs, int numQs);
struct seQuestion **se_load(char *string, int *numQs);
int se_has_update(struct seQuestion **old, int numOld, 
                  struct seQuestion *new);
void se_check_for_updates(struct seQuestion **old, int numOld, 
                          struct seQuestion **new, int numNew);

#endif
