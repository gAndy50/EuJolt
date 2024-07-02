include std/ffi.e
include std/machine.e

include joltc.e

public constant TRUE = 1, FALSE = 0

public enum type Hello_ObjectLayers
	HELLO_OL_NON_MOVING = 0,
	HELLO_OL_MOVING,
	HELLO_OL_COUNT
end type

public enum type Hello_BroadPhaseLayers
	HELLO_BPL_NON_MOVING = 0,
	HELLO_BPL_MOVING,
	HELLO_BPL_COUNT
end type

public function Hello_BPL_GetNumBroadPhaseLayers()
	return HELLO_BPL_COUNT
end function

public function Hello_BPL_GetBroadPhaseLayer(atom inLayer)
	switch inLayer do
	case HELLO_OL_NON_MOVING then
		return HELLO_BPL_NON_MOVING
	case HELLO_OL_MOVING then
		return HELLO_BPL_MOVING
	end switch
end function

atom Hello_BPL = allocate_struct(JPC_BroadPhaseLayerInterfaceFns)
atom Hello_BPL_id = routine_id("Hello_BPL_GetNumBroadPhaseLayers")
atom Hello_BPL_id2 = routine_id("Hello_BPL_GetBroadPhaseLayer")

peek_struct(call_back(Hello_BPL_id),Hello_BPL)
peek_struct(call_back(Hello_BPL_id2),Hello_BPL)

public function Hello_OVB_ShouldCollide(atom inLayer1,atom inLayer2)
	switch(inLayer1) do
	case HELLO_OL_NON_MOVING then
		return inLayer2 = HELLO_BPL_MOVING
		
	case HELLO_OL_MOVING then
		return TRUE
	end switch
end function

atom Hello_OVB = allocate_struct(JPC_ObjectVsBroadPhaseLayerFilterFns)
atom Hello_OVB_id = routine_id("Hello_OVB_ShouldCollide")
peek_struct(call_back(Hello_OVB_id),Hello_OVB)

public function Hello_OVO_ShouldCollide(atom inLayer1,atom inLayer2)
	switch inLayer1 do
	case HELLO_OL_NON_MOVING then
		return inLayer2 = HELLO_OL_MOVING
	case HELLO_OL_MOVING then
		return TRUE
	end switch
end function

public atom Hello_OVO = allocate_struct(JPC_ObjectLayerPairFilterFns)
atom Hello_OVO_id = routine_id("Hello_OVO_ShouldCollide")
peek_struct(call_back(Hello_OVO_id),JPC_ObjectLayerPairFilterFns)

public procedure main()
	JPC_RegisterDefaultAllocator()
	JPC_FactoryInit()
	JPC_RegisterTypes()
	
	atom temp_allocator = JPC_TempAllocatorImpl_new(10 * 1024 * 1024)
	
	atom job_system = JPC_JobSystemThreadPool_new2(JPC_MAX_PHYSICS_JOBS,JPC_MAX_PHYSICS_BARRIERS)
	
	atom broad_phase_layer_interface = JPC_BroadPhaseLayerInterface_new(NULL,peek_struct(C_POINTER,JPC_BroadPhaseLayerInterfaceFns))
	atom object_vs_broad_phase_layer_filter = JPC_ObjectVsBroadPhaseLayerFilter_new(NULL,peek_struct(C_POINTER,JPC_ObjectVsBroadPhaseLayerFilterFns))
	atom object_vs_object_layer_filter = JPC_ObjectLayerPairFilter_new(NULL,peek_struct(C_POINTER,JPC_ObjectLayerPairFilterFns))
	
	atom cMaxBodies = 1024
	atom cNumBodyMutexes = 0
	atom cMaxBodyPairs = 1024
	atom cMaxContactConstraints = 1024
	
	atom physics_system = JPC_PhysicsSystem_new()
	
	JPC_PhysicsSystem_Init(physics_system,cMaxBodies,cNumBodyMutexes,cMaxBodyPairs,cMaxContactConstraints,broad_phase_layer_interface,object_vs_broad_phase_layer_filter,object_vs_object_layer_filter)
	
	atom body_interface = JPC_PhysicsSystem_GetBodyInterface(physics_system)
	
	object floor_shape_settings = JPC_BoxShapeSettings
	JPC_BoxShapeSettings_default(floor_shape_settings)
	floor_shape_settings[3] = {100.0,1.0,100.0}
	floor_shape_settings[2] = 500.0
	
	atom floor_shape
	if JPC_BoxShapeSettings_Create(floor_shape_settings,floor_shape,NULL) = -1 then
		puts(1,"Failed to create shape!\n")
	end if
	
	atom floor_settings = JPC_BodyCreationSettings
	JPC_BodyCreationSettings_default(floor_settings)
	floor_settings[1] = {0.0,-1.0,0.0} --floor_settings.position
	floor_settings[7] = JPC_MOTION_TYPE_STATIC --floor_settings.MotionType
	floor_settings[6] = HELLO_OL_NON_MOVING --floor_settings.ObjectLayer
	floor_settings[28] = floor_shape --floor_settings.Shape
	
	atom static_floor = JPC_BodyInterface_CreateBody(body_interface,floor_settings)
	JPC_BodyInterface_AddBody(body_interface,JPC_Body_GetID(static_floor),JPC_ACTIVATION_DONT_ACTIVATE)
	
	atom sphere_shape_settings = JPC_SphereShapeSettings
	JPC_SphereShapeSettings_default(sphere_shape_settings)
	sphere_shape_settings[3] = 0.5 --sphere_shape_settings.radius
	
	atom sphere_shape
	if JPC_SphereShapeSettings_Create(sphere_shape_settings,sphere_shape,NULL) = -1 then
		puts(1,"Failed to create sphere!\n")
	end if
	
	atom sphere_settings = JPC_BodyCreationSettings
	JPC_BodyCreationSettings_default(sphere_settings)
	sphere_settings[1] = {0.0,2.0,0.0}
	sphere_settings[7] = JPC_MOTION_TYPE_DYNAMIC
	sphere_settings[6] = HELLO_OL_MOVING
	sphere_settings[28] = sphere_shape
	
	atom sphere = JPC_BodyInterface_CreateBody(body_interface,sphere_settings)
	atom sphere_id = JPC_Body_GetID(sphere)
	JPC_BodyInterface_AddBody(body_interface,sphere_id,JPC_ACTIVATION_ACTIVATE)
	
	JPC_BodyInterface_SetLinearVelocity(body_interface,sphere_id,{0,0,-5.0,0.0})
	
	JPC_PhysicsSystem_OptimizeBroadPhase(physics_system)
	
	atom cDeltaTime = 1.0 / 60.0
	atom cCollisionSteps = 1
	
	atom step = 0
	while JPC_BodyInterface_IsActive(body_interface,sphere_id) do
		step += 1
		
		sequence pos = JPC_BodyInterface_GetCenterOfMassPosition(body_interface,sphere_id)
		sequence vel = JPC_BodyInterface_GetLinearVelocity(body_interface,sphere_id)
		
			printf(1,"Steps: %d, Pos: %f, %f, %f, Vel = %f, %f, %f\n",{step,pos[1],pos[2],pos[3],vel[1],vel[2],vel[3]})
		
		JPC_PhysicsSystem_Update(physics_system,cDeltaTime,cCollisionSteps,temp_allocator,job_system)
	end while
	
	JPC_BodyInterface_RemoveBody(body_interface,sphere_id)
	JPC_BodyInterface_DestroyBody(body_interface,sphere_id)
	
	JPC_BodyInterface_RemoveBody(body_interface,JPC_Body_GetID(static_floor))
	JPC_BodyInterface_DestroyBody(body_interface,JPC_Body_GetID(static_floor))
	
	JPC_PhysicsSystem_delete(physics_system)
	JPC_BroadPhaseLayerInterface_delete(broad_phase_layer_interface)
	JPC_ObjectVsBroadPhaseLayerFilter_delete(object_vs_broad_phase_layer_filter)
	JPC_ObjectLayerPairFilter_delete(object_vs_object_layer_filter)
	
	JPC_JobSystemThreadPool_delete(job_system)
	JPC_TempAllocatorImpl_delete(temp_allocator)
	
	JPC_UnregisterTypes()
	JPC_FactoryDelete()
	
	puts(1,"Hello World\n")
	
end procedure
	
main()
­167.24