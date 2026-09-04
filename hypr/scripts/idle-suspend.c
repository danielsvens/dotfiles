#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

static int ensure_dir(const char *path) {
    if (mkdir(path, 0755) == 0 || errno == EEXIST) {
        return 0;
    }

    perror("mkdir");
    return 1;
}

static int read_state(const char *path) {
    FILE *file = fopen(path, "r");

    if (!file) {
        file = fopen(path, "w");
        if (!file) {
            perror("fopen");
            return -1;
        }

        fputs("0", file);
        fclose(file);
        return 0;
    }

    int ch = fgetc(file);
    fclose(file);

    return ch == '1' ? 1 : 0;
}

static int write_state(const char *path, int disabled) {
    FILE *file = fopen(path, "w");
    if (!file) {
        perror("fopen");
        return 1;
    }

    fputc(disabled ? '1' : '0', file);
    fclose(file);
    return 0;
}

static void print_status(int disabled) {
    if (disabled) {
        puts("{\"text\":\"\",\"tooltip\":\"Idle suspend paused\\nLock after 5 minutes stays active\"}");
    } else {
        puts("{\"text\":\"󰒲\",\"tooltip\":\"Idle suspend active\\nLock after 5 minutes, suspend after 10 minutes\"}");
    }
}

static int toggle_state(const char *state_path, int disabled) {
    int next = !disabled;

    if (write_state(state_path, next) != 0) {
        return 1;
    }

    const char *command = next
        ? "notify-send \"Idle suspend\" \"Suspend after 10 minutes paused\""
        : "notify-send \"Idle suspend\" \"Suspend after 10 minutes re-enabled\"";

    return system(command) == -1 ? 1 : 0;
}

static int suspend_if_enabled(int disabled) {
    if (!disabled) {
        return system("systemctl suspend") == -1 ? 1 : 0;
    }

    return 0;
}

int main(int argc, char **argv) {
    const char *home = getenv("HOME");
    if (!home) {
        fputs("HOME is not set\n", stderr);
        return 1;
    }

    char cache_dir[PATH_MAX];
    char state_path[PATH_MAX];

    snprintf(cache_dir, sizeof(cache_dir), "%s/.config/hypr/.cache", home);
    snprintf(state_path, sizeof(state_path), "%s/.idle_suspend_disabled", cache_dir);

    if (ensure_dir(cache_dir) != 0) {
        return 1;
    }

    int disabled = read_state(state_path);
    if (disabled < 0) {
        return 1;
    }

    if (argc > 1 && strcmp(argv[1], "--toggle") == 0) {
        return toggle_state(state_path, disabled);
    }

    if (argc > 1 && strcmp(argv[1], "--suspend-if-enabled") == 0) {
        return suspend_if_enabled(disabled);
    }

    print_status(disabled);
    return 0;
}
