import 'package:background_fetch/background_fetch.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
  void backgroundFetchHeadlessTask(HeadlessTask task) async {
    String taskId = task.taskId;
    bool isTimeout = task.timeout;
    if (isTimeout) {
      // This task has exceeded its allowed running-time.
      // You must stop what you're doing and immediately .finish(taskId)
      Get.log("[BackgroundFetch] Headless task timed-out: $taskId");
      BackgroundFetch.finish(taskId);
      return;
    }
    Get.log('[BackgroundFetch] Headless event received.');
    // Do your work here...
    BackgroundFetch.finish(taskId);
  }

final backgroundFetchManager = BackgroundFetchManager();

class BackgroundFetchManager {
  void register() async {
    await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    await initPlatformState();
  }

  void startBackgroundFetch() {
    BackgroundFetch.start().then((int status) {
      Get.log('[BackgroundFetch] start success: $status');
    }).catchError((e) {
      Get.log('[BackgroundFetch] start FAILURE: $e');
    });
  }

  Future<void> initPlatformState() async {
    int status = await BackgroundFetch.configure(
      BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE
          // 更多配置项...
          ),
      (String taskId) async {
        // <-- Event handler
        // 处理后台任务事件
        // ...
        switch (taskId) {
          case 'com.mqtt.mqttConnect':
            break;
        }
        // 完成任务
        BackgroundFetch.finish(taskId);
      },
      (String taskId) async {
        // <-- Task timeout handler
        // 处理任务超时
        // ...

        // 完成任务
        BackgroundFetch.finish(taskId);
      },
    );
    Get.log('[BackgroundFetch] configure success: $status');

    // 配置定时任务
    BackgroundFetch.scheduleTask(TaskConfig(
        taskId: 'com.mqtt.mqttConnect',
        delay: 5000, // 毫秒
        forceAlarmManager: true,
        periodic: true));

    // if (!mounted) return;
  }
}
