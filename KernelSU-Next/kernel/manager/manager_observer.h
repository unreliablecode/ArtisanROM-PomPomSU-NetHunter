#ifndef __KSU_H_MANAGER_OBSERVER
#define __KSU_H_MANAGER_OBSERVER

#ifdef CONFIG_KSU_DISABLE_MANAGER
static inline int ksu_observer_init(void)
{
    return 0;
}

static inline void ksu_observer_exit(void)
{
}
static inline void ksu_observer_retry(void)
{
}
static inline void ksu_defer_track_throne(void)
{
}
#else
int ksu_observer_init(void);
void ksu_observer_exit(void);
void ksu_observer_retry(void);
void ksu_defer_track_throne(void);
#endif

#endif // __KSU_H_MANAGER_OBSERVER
