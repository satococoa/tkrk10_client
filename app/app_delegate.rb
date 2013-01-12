class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(App.bounds)
    controller = UIViewController.new
    controller.view.backgroundColor = UIColor.whiteColor
    @window.rootViewController = controller
    @window.makeKeyAndVisible
    true
  end
end
