
    function onTransition(params) {
        local ttime = params.ttime;
        local ttype = params.ttype;
        local var = params.var;
        local busy = false;
        foreach (o in ExtendedObjects.objects) {
            foreach (a in o.config.animations) {
                if (ttype == a.config.when) {
                    //ExtendedDebugger.notice(ttime + "starting transition: " + Animate.getWhen(a.config.when) + " : " + o.id);
                    if (!a.running) {
                        startAnimation(ttime, o, a);
                    } else {
                        if (a.config.restart) {
                            a.createdAt = null;
                            a.playCount = 0;
                        }
                    }
                }
                /*
                if (a.running) {
                    if (ttype == a.config.when) {
                        //restart transition animations if restart option is enabled
                        if (a.config.restart) {
                            a.createdAt = null;
                            a.playCount = 0;
                        }
                        if (update(ttime, o, a) == true) busy = true;
                    } else {
                        //continue executing non-waiting animations (even if there are waiting animations)
                        update(ttime, o, a);
                    }
                }
                */
            }
        }
        return busy;
    }
    
    function onTick(params) {
        //TODO - handle animations that don't "wait" or that don't rely on transitions
        local ttime = params.ttime;
        foreach (o in ExtendedObjects.objects) {
            foreach (a in o.config.animations) {
                //TODO - what needs to be done with this?
                //       look for non-running animations and see if we should start them
                if (!a.running) {
                    //check if we should start the animation
                    switch (a.config.when) {
                        case When.Always:
                            startAnimation(ttime, o, a);
                            break;
                    }
                }
                if (a.running) {
                    //handle running animations
                    update(ttime, o, a);
                }
            }
        }
    }

    function update(ttime, o, a) {
        local busy = false;
        if (a.createdAt == null) a.createdAt = ttime;
        a.currentTime = ttime - a.createdAt - a.config.delay;
            
        if (a.running) {
            //run this after the delay occurs
            if (a.currentTime >= 0) {
                if (a.currentTime < a.config.duration) {
                    //runFrames while playCount less than the number of requested plays
                    if (a.playCount <= (a.config.repeat + 1)) runFrame(a.currentTime * (a.config.repeat + 1), o, a);
                    //if we reach the length of one play, run again - increasing the play count
                    if (a.currentTime >= a.config.duration / (a.config.repeat + 1)) { 
                        a.createdAt = null;
                        a.playCount += 1;
                        if (a.playCount < (a.config.repeat + 1)) {
                            //handle special case scenarios for repeats
                            if (a.config.kind == "yoyo" && a.playCount >=1 ) a.config.reverse = !a.config.reverse;
                            //restart by setting createdAt to null
                        } else {
                            //reached the last play, stop the animations
                            //ExtendedDebugger.notice("loop stop");
                            stopAnimation(a.currentTime, o, a);
                            //handle special case scenarios for repeats
                            if (a.config.kind == "yoyo") a.config.reverse = false;
                        }
                    }
                } else {
                    stopAnimation(a.currentTime, o, a);
                    //ExtendedDebugger.notice("time stop");
                }
            }
            if (a.config.wait) busy = true;
            ExtendedDebugger.notice("Started animation: " + o.id + ": created at: " + a.createdAt + " ttime: " + ttime + " current: " + a.currentTime + " dur: " + a.config.duration + " pc: " + a.playCount);

            
            //check if we need to stop
            //if (a.currentTime > a.config.duration) {
            //    stopAnimation(a.currentTime, o, a);
                //ExtendedDebugger.notice("stopped transition");
            //} else {
            //    if (a.config.wait) busy = true;
            //}
        }
        return busy;
    }
    
    //starts the animation
    function startAnimation(ttime, o, a) {
        a.createdAt = null;
        a.running = true;
        a.playCount = 0;
        a.start(o);
        ExtendedObjects.run_callback("onAnimationStart", { ttime = ttime, object = o, animation = a } );
    }
    
    //executes an animation frame
    function runFrame(ttime, o, a) {
        //execute frame
        a.frame(o, ttime);
        ExtendedObjects.run_callback("onAnimationFrame", { ttime = ttime, object = o, animation = a } );
    }
    
     //stops the animation
    function stopAnimation(ttime, o, a) {
        a.running = false;
        a.createdAt = null;
        a.currentTime = 0;
        a.playCount = 0;
        a.frame(o, a.config.duration);
        a.stop(o);
        ExtendedObjects.run_callback("onAnimationStop", { ttime = ttime, object = o, animation = a } );
    }