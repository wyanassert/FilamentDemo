//
//  FilamentViewController.m
//  FilamentDemo
//
//  Created by wyan on 2023/6/2.
//

#import "FilamentViewController.h"
#import <MetalKit/MTKView.h>
#include <filament/Engine.h>
#include <filament/Renderer.h>
#include <filament/View.h>
#include <filament/Camera.h>
#include <filament/Scene.h>
#include <filament/Viewport.h>

#include <utils/Entity.h>
#include <utils/EntityManager.h>

using namespace utils;

using namespace filament;

@interface FilamentViewController () <MTKViewDelegate>

@end

@implementation FilamentViewController {
    Engine* _engine;
    SwapChain* _swapChain;
    Renderer* _renderer;
    View* _view;
    Scene* _scene;
    Camera* _camera;
    Entity _cameraEntity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view = [[MTKView alloc] initWithFrame:self.view.frame];
    _engine = Engine::create(Engine::Backend::METAL);
    
    MTKView* mtkView = (MTKView*) self.view;
    mtkView.delegate = self;
    _swapChain = _engine->createSwapChain((__bridge void*) mtkView.layer);
    
    _renderer = _engine->createRenderer();
    _view = _engine->createView();
    _scene = _engine->createScene();
    
    _cameraEntity = EntityManager::get().create();
    _camera = _engine->createCamera(_cameraEntity);
    
    _renderer->setClearOptions({
        .clearColor = {0.25f, 0.5f, 1.0f, 1.0f},
        .clear = true
    });
    
    _view->setScene(_scene);
    _view->setCamera(_camera);
    
    [self resize:mtkView.drawableSize];
}

- (void)dealloc {
    
    _engine->destroyCameraComponent(_cameraEntity);
    EntityManager::get().destroy(_cameraEntity);
    _engine->destroy(_scene);
    _engine->destroy(_view);
    _engine->destroy(_renderer);
    
    _engine->destroy(_swapChain);
    _engine->destroy(&_engine);
}

#pragma mark - Private

- (void)resize:(CGSize)size {
    _view->setViewport({0, 0, (uint32_t) size.width, (uint32_t) size.height});

    const double aspect = size.width / size.height;
    const double left   = -2.0 * aspect;
    const double right  =  2.0 * aspect;
    const double bottom = -2.0;
    const double top    =  2.0;
    const double near   =  0.0;
    const double far    =  1.0;
    _camera->setProjection(Camera::Projection::ORTHO, left, right, bottom, top, near, far);
}

#pragma mark - MTKViewDelegate
- (void)mtkView:(nonnull MTKView*)view drawableSizeWillChange:(CGSize)size {
    [self resize:size];
}

- (void)drawInMTKView:(nonnull MTKView*)view {
    if (_renderer->beginFrame(_swapChain)) {
        _renderer->render(_view);
        _renderer->endFrame();
    }
}

@end
