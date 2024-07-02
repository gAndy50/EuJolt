-------------------------------------------
--EuJolt
--Written by Andy P.
--Jolt Physics wrapper for OpenEuphoria
--Icy Viking Games
--Based off of JoltC port
--Copyright (c) 2024
--32-Bits Euphoria
-------------------------------------------
include std/ffi.e
include std/machine.e
include std/os.e

public atom jolt

ifdef WINDOWS then
	jolt = open_dll("joltc.dll")
	elsifdef LINUX or FREEBSD then
	jolt = open_dll("libjoltc.so")
	elsifdef OSX then
	jolt = open_dll("libjoltc.dylib")
end ifdef

if jolt = 0 then
	puts(1,"Failed to load JoltC DLL!\n")
	abort(0)
end if

--printf(1,"%d",{jolt}) --for testing purposes

public constant JPC_MAX_PHYSICS_JOBS = 2048
public constant JPC_MAX_PHYSICS_BARRIERS = 8

public enum type JPC_ShapeType
	JPC_SHAPE_TYPE_CONVEX = 0,
    JPC_SHAPE_TYPE_COMPOUND,
    JPC_SHAPE_TYPE_DECORATED,
    JPC_SHAPE_TYPE_MESH,
    JPC_SHAPE_TYPE_HEIGHT_FIELD,
    JPC_SHAPE_TYPE_SOFTBODY,
    JPC_SHAPE_TYPE_USER1,
    JPC_SHAPE_TYPE_USER2,
    JPC_SHAPE_TYPE_USER3,
    JPC_SHAPE_TYPE_USER4
end type

public enum type JPC_ShapeSubType
	JPC_SHAPE_SUB_TYPE_SPHERE = 0,
    JPC_SHAPE_SUB_TYPE_BOX,
    JPC_SHAPE_SUB_TYPE_TRIANGLE,
    JPC_SHAPE_SUB_TYPE_CAPSULE,
    JPC_SHAPE_SUB_TYPE_TAPEREDCAPSULE,
    JPC_SHAPE_SUB_TYPE_CYLINDER,
    JPC_SHAPE_SUB_TYPE_CONVEX_HULL,
    JPC_SHAPE_SUB_TYPE_STATIC_COMPOUND,
    JPC_SHAPE_SUB_TYPE_MUTABLE_COMPOUND,
    JPC_SHAPE_SUB_TYPE_ROTATED_TRANSLATED,
    JPC_SHAPE_SUB_TYPE_SCALED,
    JPC_SHAPE_SUB_TYPE_OFFSET_CENTER_OF_MASS,
    JPC_SHAPE_SUB_TYPE_MESH,
    JPC_SHAPE_SUB_TYPE_HEIGHT_FIELD,
    JPC_SHAPE_SUB_TYPE_SOFT_BODY,
    JPC_SHAPE_SUB_TYPE_USER1,
    JPC_SHAPE_SUB_TYPE_USER2,
    JPC_SHAPE_SUB_TYPE_USER3,
    JPC_SHAPE_SUB_TYPE_USER4,
    JPC_SHAPE_SUB_TYPE_USER5,
    JPC_SHAPE_SUB_TYPE_USER6,
    JPC_SHAPE_SUB_TYPE_USER7,
    JPC_SHAPE_SUB_TYPE_USER8,
    JPC_SHAPE_SUB_TYPE_USER_CONVEX1,
    JPC_SHAPE_SUB_TYPE_USER_CONVEX2,
    JPC_SHAPE_SUB_TYPE_USER_CONVEX3,
    JPC_SHAPE_SUB_TYPE_USER_CONVEX4,
    JPC_SHAPE_SUB_TYPE_USER_CONVEX5,
    JPC_SHAPE_SUB_TYPE_USER_CONVEX6,
    JPC_SHAPE_SUB_TYPE_USER_CONVEX7,
    JPC_SHAPE_SUB_TYPE_USER_CONVEX8
end type

public constant JPC_PhysicsUpdateError = C_UINT32

public constant JPC_PHYSICS_UPDATE_ERROR_NONE = 0,
				JPC_PHYSICS_UPDATE_ERROR_MANIFOLD_CACHE_FULL = 1, -- 1 << 0
				JPC_PHYSICS_UPDATE_BODY_PAIR_CACHE_FULL = 2, -- 1 << 1
				JPC_PHYSICS_UPDATE_ERROR_CONTACT_CONSTRAINTS_FULL = 4 -- 1 << 2
				
public enum type JPC_ConstraintType
	JPC_CONSTRAINT_TYPE_CONSTRAINT = 0,
	JPC_CONSTRAINT_TYPE_TWO_BODY_CONSTRAINT
end type

public enum type JPC_ConstraintSubType
	JPC_CONSTRAINT_SUB_TYPE_FIXED = 0,
    JPC_CONSTRAINT_SUB_TYPE_POINT,
    JPC_CONSTRAINT_SUB_TYPE_HINGE,
    JPC_CONSTRAINT_SUB_TYPE_SLIDER,
    JPC_CONSTRAINT_SUB_TYPE_DISTANCE,
    JPC_CONSTRAINT_SUB_TYPE_CONE,
    JPC_CONSTRAINT_SUB_TYPE_SWING_TWIST,
    JPC_CONSTRAINT_SUB_TYPE_SIX_DOF,
    JPC_CONSTRAINT_SUB_TYPE_PATH,
    JPC_CONSTRAINT_SUB_TYPE_VEHICLE,
    JPC_CONSTRAINT_SUB_TYPE_RACK_AND_PINION,
    JPC_CONSTRAINT_SUB_TYPE_GEAR,
    JPC_CONSTRAINT_SUB_TYPE_PULLEY,
    JPC_CONSTRAINT_SUB_TYPE_USER1,
    JPC_CONSTRAINT_SUB_TYPE_USER2,
    JPC_CONSTRAINT_SUB_TYPE_USER3,
    JPC_CONSTRAINT_SUB_TYPE_USER4
end type

public enum type JPC_ConstraintSpace
	JPC_CONSTRAINT_SPACE_LOCAL_TO_BODY_COM = 0,
	JPC_CONSTRAINT_SPACE_WORLD_SPACE
end type

public enum type JPC_MotionType
	JPC_MOTION_TYPE_STATIC = 0,
	JPC_MOTION_TYPE_KINEMATIC,
	JPC_MOTION_TYPE_DYNAMIC
end type

public enum type JPC_MotionQuality
	JPC_MOTION_QUALITY_DISCRETE = 0,
	JPC_MOTION_QUALITY_LINEAR_CAST
end type

public enum type JPC_OverrideMassProperties
	JPC_OVERRIDE_MASS_PROPS_CALC_MASS_INERTIA = 0,
	JPC_OVERRIDE_MASS_PROPS_CALC_INERTIA,
	JPC_OVERRIDE_MASS_PROPS_MASS_INERTIA_PROVIDED
end type

public enum type JPC_GroundState
	JPC_CHARACTER_GROUND_STATE_ON_GROUND = 0,
	JPC_CHARACTER_GROUND_STATE_ON_STEEP_GROUND,
	JPC_CHARACTER_GROUND_STATE_NOT_SUPPORTED,
	JPC_CHARACTER_GROUND_STATE_IN_AIR
end type

public enum type JPC_Activation
	JPC_ACTIVATION_ACTIVATE = 0,
	JPC_ACTIVATION_DONT_ACTIVATE = 1
end type

public enum type JPC_ValidateResult
	JPC_VALIDATE_RESULT_ACCEPT_ALL_CONTACTS = 0,
    JPC_VALIDATE_RESULT_ACCEPT_CONTACT,
    JPC_VALIDATE_RESULT_REJECT_CONTACT,
    JPC_VALIDATE_RESULT_REJECT_ALL_CONTACTS
end type

public enum type JPC_BackFaceMode
	JPC_BACK_FACE_IGNORE = 0,
	JPC_BACK_FACE_COLLIDE
end type

public enum type JPC_BodyType
	JPC_BODY_TYPE_RIGID_BODY = 0,
	JPC_BODY_TYPE_SOFT_BODY = 1
end type

public enum type JPC_AllowedDOFs
	JPC_ALLOWED_DOFS_NONE         = 0b000000,
    JPC_ALLOWED_DOFS_ALL          = 0b111111,
    JPC_ALLOWED_DOFS_TRANSLATIONX = 0b000001,
    JPC_ALLOWED_DOFS_TRANSLATIONY = 0b000010,
    JPC_ALLOWED_DOFS_TRANSLATIONZ = 0b000100,
    JPC_ALLOWED_DOFS_ROTATIONX    = 0b001000,
    JPC_ALLOWED_DOFS_ROTATIONY    = 0b010000,
    JPC_ALLOWED_DOFS_ROTATIONZ    = 0b100000
end type

public enum type JPC_Features
	JPC_FEATURE_DOUBLE_PRECISION = 1, -- 1 << 0
	JPC_FEATURE_NEON = 2, -- 1 << 1
	JPC_FEATURE_SSE = 4, -- 1 << 2
	JPC_FEATURE_SSE4_1 = 8, -- 1 << 3
	JPC_FEATURE_SSE4_2 = 16, --1 << 4
	JPC_FEATURE_AVX = 32, -- 1 << 5
	JPC_FEATURE_AVX2 = 64, -- 1 << 6
	JPC_FEATURE_AVX512 = 128, -- 1 << 7
	JPC_FEATURE_F16C = 256, -- 1 << 8
	JPC_FEATURE_LZCNT = 512, -- 1 << 9
	JPC_FEATURE_TZCNT = 1024, -- 1 << 10
	JPC_FEATURE_FMADD = 2048, -- 1 << 11
	JPC_FEATURE_PLATFORM_DETERMINISTIC = 4096, -- 1 << 12
	JPC_FEATURE_FLOATING_POINT_EXCEPTIONS = 8192, -- 1 << 13
	JPC_FEATURE_DEBUG = 16384 -- 1 << 14
end type

public constant JPC_ShapeColor = C_INT

public constant JPC_SHAPE_COLOR_INSTANCE_COLOR = 0,
				JPC_SHAPE_COLOR_SHAPE_TYPE_COLOR = 1,
				JPC_SHAPE_COLOR_MOTION_TYPE_COLOR = 2,
				JPC_SHAPE_COLOR_SLEEP_COLOR = 3,
				JPC_SHAPE_COLOR_ISLAND_COLOR = 4,
				JPC_SHAPE_COLOR_MATERIAL_COLOR = 5

public constant JPC_PI = 3.14159265358979323846

public constant xJPC_RegisterDefaultAllocator = define_c_proc(jolt,"+JPC_RegisterDefaultAllocator",{}),
				xJPC_FactoryInit = define_c_proc(jolt,"+JPC_FactoryInit",{}),
				xJPC_FactoryDelete = define_c_proc(jolt,"+JPC_FactoryDelete",{}),
				xJPC_RegisterTypes = define_c_proc(jolt,"+JPC_RegisterTypes",{}),
				xJPC_UnregisterTypes = define_c_proc(jolt,"+JPC_UnregisterTypes",{})

public procedure JPC_RegisterDefaultAllocator()
	c_proc(xJPC_RegisterDefaultAllocator,{})
end procedure

public procedure JPC_FactoryInit()
	c_proc(xJPC_FactoryInit,{})	
end procedure

public procedure JPC_FactoryDelete()
	c_proc(xJPC_FactoryDelete,{})
end procedure

public procedure JPC_RegisterTypes()
	c_proc(xJPC_RegisterTypes,{})
end procedure

public procedure JPC_UnregisterTypes()
	c_proc(xJPC_UnregisterTypes,{})
end procedure

public constant JPC_Float3 = define_c_struct({
	C_FLOAT, --x
	C_FLOAT, --y
	C_FLOAT  --z
})

public constant JPC_Vec3 = define_c_struct({
	C_FLOAT, --x
	C_FLOAT, --y
	C_FLOAT, --z
	C_FLOAT  --w
})

public constant JPC_Vec4 = define_c_struct({
	C_FLOAT, --x
	C_FLOAT, --y
	C_FLOAT, --z
	C_FLOAT  --w
})

public constant JPC_DVec3 = define_c_struct({
	C_DOUBLE, --x
	C_DOUBLE, --y
	C_DOUBLE, --z
	C_DOUBLE --w
})

public constant JPC_Quat = define_c_struct({
	C_FLOAT, --x
	C_FLOAT, --y
	C_FLOAT, --z
	C_FLOAT  --w
})

public constant JPC_Mat44 = define_c_struct({
	{JPC_Vec4,4} --matrix[4]
})

public constant JPC_DMatt4 = define_c_struct({
	{JPC_Vec4,3}, --col[3]
	JPC_DVec3 --col3
})

public constant JPC_Color = define_c_struct({
	C_UINT8, --r
	C_UINT8, --g
	C_UINT8, --b
	C_UINT8  --a
})

ifdef JPC_DOUBLE_PRECISION then
	public constant JPC_RVec3 = JPC_DVec3
	public constant JPC_RMat44 = JPC_DMat44
	public constant Real = C_DOUBLE
	elsedef
	public constant JPC_RVec3 = JPC_Vec3
	public constant JPC_RMat44 = JPC_Mat44
	public constant Real = C_FLOAT
end ifdef

public constant JPC_BodyID = C_UINT32

public constant JPC_SubShapeID = C_UINT32

public constant JPC_BroadPhaseLayer = C_UINT8

ifdef JPC_OBJECT_LAYER_BITS then
	public constant JPC_OBJECT_LAYER_BITS = 16
end ifdef

public constant JPC_ObjectLayer = C_UINT32 --change to C_UINT16 if want 16 bits

public constant JPC_IndexedTriangleNoMaterial = define_c_struct({
	{C_UINT32,3} --idx[3]
})

public constant JPC_IndexedTriangle = define_c_struct({
	{C_UINT32,3}, --idx[3]
	C_UINT32 --materialIndex
})

public constant JPC_RayCast = define_c_struct({
	JPC_Vec3, --origin
	JPC_Vec3 --direction
})

public constant JPC_RRayCast = define_c_struct({
	JPC_RVec3, --origin
	JPC_Vec3 --direction
})

public constant JPC_RayCastResult = define_c_struct({
	JPC_BodyID, --BodyID
	C_FLOAT, --fraction
	JPC_SubShapeID --subShapeID2
})

--VertexList == Array<Float3> == std::vector<Float3>
public constant xJPC_VertexList_new = define_c_func(jolt,"+JPC_VertexList_new",{C_POINTER,C_SIZE_T},C_POINTER),
				xJPC_VertexList_delete = define_c_proc(jolt,"+JPC_VertexList_delete",{C_POINTER})
				
public function JPC_VertexList_new(atom storage,atom len)
	return c_func(xJPC_VertexList_new,{storage,len})
end function

public procedure JPC_VertexList_delete(atom obj)
	c_proc(xJPC_VertexList_delete,{obj})
end procedure

--IndexedTriangleList == Array<IndexedTriangle> == std::vector<IndexedTriangle>
public constant xJPC_IndexedTriangleList_new = define_c_func(jolt,"+JPC_IndexedTriangleList_new",{C_POINTER,C_SIZE_T},C_POINTER),
				xJPC_IndexedTriangleList_delete = define_c_proc(jolt,"+JPC_IndexedTriangleList_delete",{C_POINTER})
				
public function JPC_IndexedTriangleList_new(atom storage,atom len)
	return c_func(xJPC_IndexedTriangleList_new,{storage,len})
end function

public procedure JPC_IndexedTriangleList_delete(atom obj)
	c_proc(xJPC_IndexedTriangleList_delete,{obj})
end procedure

--TempAllocatorImpl

public constant xJPC_TempAllocatorImpl_new = define_c_func(jolt,"+JPC_TempAllocatorImpl_new",{C_UINT},C_POINTER),
				xJPC_TempAllocatorImpl_delete = define_c_proc(jolt,"+JPC_TempAllocatorImpl_delete",{C_POINTER})
				
public function JPC_TempAllocatorImpl_new(atom size)
	return c_func(xJPC_TempAllocatorImpl_new,{size})
end function

public procedure JPC_TempAllocatorImpl_delete(atom obj)
	c_proc(xJPC_TempAllocatorImpl_delete,{obj})
end procedure

--JobSystemThreadPool

public constant xJPC_JobSystemThreadPool_new2 = define_c_func(jolt,"+JPC_JobSystemThreadPool_new2",{C_UINT,C_UINT},C_POINTER),
				xJPC_JobSystemThreadPool_new3 = define_c_func(jolt,"+JPC_JobSystemThreadPool_new3",{C_UINT,C_UINT,C_INT},C_POINTER),
				xJPC_JobSystemThreadPool_delete = define_c_proc(jolt,"+JPC_JobSystemThreadPool_delete",{C_POINTER})
				
public function JPC_JobSystemThreadPool_new2(atom inMaxJobs,atom inMaxBarriers)
	return c_func(xJPC_JobSystemThreadPool_new2,{inMaxJobs,inMaxBarriers})
end function

public function JPC_JobSystemThreadPool_new3(atom inMaxJobs,atom inMaxBarriers,atom inNumThreads)
	return c_func(xJPC_JobSystemThreadPool_new3,{inMaxJobs,inMaxBarriers,inNumThreads})
end function

public procedure JPC_JobSystemThreadPool_delete(atom obj)
	c_proc(xJPC_JobSystemThreadPool_delete,{obj})
end procedure

--BroadPhaseLayerInterface

public constant JPC_BroadPhaseLayerInterfaceFns = define_c_struct({
	C_POINTER, --GetNumBroadPhaseLayers
	C_POINTER, --self (*GetNumBroadPhaseLayers)(const void *self);
	C_POINTER, --GetBroadphaseLayer
	C_POINTER, --self (*GetBroadPhaseLayer)(const void *self, JPC_ObjectLayer inLayer);
	C_UINT32 --inLayer JPC_ObjectLayer
})

public constant xJPC_BroadPhaseLayerInterface_new = define_c_func(jolt,"+JPC_BroadPhaseLayerInterface_new",{C_POINTER,JPC_BroadPhaseLayerInterfaceFns},C_POINTER),
				xJPC_BroadPhaseLayerInterface_delete = define_c_proc(jolt,"+JPC_BroadPhaseLayerInterface_delete",{C_POINTER})
				
public function JPC_BroadPhaseLayerInterface_new(atom self,sequence fns)
	return c_func(xJPC_BroadPhaseLayerInterface_new,{self,fns})
end function

public procedure JPC_BroadPhaseLayerInterface_delete(atom obj)
	c_proc(xJPC_BroadPhaseLayerInterface_delete,{obj})
end procedure

--BroadPhaseLayerFilter

public constant JPC_BroadPhaseLayerFilterFns = define_c_struct({
	C_POINTER, --shouldCollide
	C_POINTER, --self
	JPC_BroadPhaseLayer --inLayer
})

public constant xJPC_BroadPhaseLayerFilter_new = define_c_func(jolt,"+JPC_BroadPhaseLayerFilter_new",{C_POINTER,JPC_BroadPhaseLayerFilterFns},C_POINTER),
				xJPC_BroadPhaseLayerFilter_delete = define_c_proc(jolt,"+JPC_BroadPhaseLayerFilter_delete",{C_POINTER})
				
public function JPC_BroadPhaseLayerFilter_new(atom self,sequence fns)
	return c_func(xJPC_BroadPhaseLayerFilter_new,{self,fns})
end function

public procedure JPC_BroadPhaseLayerFilter_delete(atom obj)
	c_proc(xJPC_BroadPhaseLayerFilter_delete,{obj})
end procedure

--ObjectLayerFilter

public constant JPC_ObjectLayerFilterFns = define_c_struct({
	C_POINTER, --shouldCollide
	C_POINTER, --self
	JPC_ObjectLayer --inLayer
})

public constant xJPC_ObjectLayerFilter_new = define_c_func(jolt,"+JPC_ObjectLayerFilter_new",{C_POINTER,JPC_ObjectLayerFilterFns},C_POINTER),
				xJPC_ObjectLayerFilter_delete = define_c_proc(jolt,"+JPC_ObjectLayerFilter_delete",{C_POINTER})
				
public function JPC_ObjectLayerFilter_new(atom self,sequence fns)
	return c_func(xJPC_ObjectLayerFilter_new,{self,fns})
end function

public procedure JPC_ObjectLayerFilter_delete(atom obj)
	c_proc(xJPC_ObjectLayerFilter_delete,{obj})
end procedure

--BodyFilter

public constant JPC_BodyFilterFns = define_c_struct({
	C_POINTER, --shouldCollide
	C_POINTER, --self
	JPC_BodyID, --inBodyID
	C_POINTER, --shouldCollideLocked
	C_POINTER, --self
	C_POINTER --inBodyID*
})

public constant xJPC_BodyFilter_new = define_c_func(jolt,"+JPC_BodyFilter_new",{C_POINTER,JPC_BodyFilterFns},C_POINTER),
				xJPC_BodyFilter_delete = define_c_proc(jolt,"+JPC_BodyFilter_delete",{C_POINTER})
				
public function JPC_BodyFilter_new(atom self,sequence fns)
	return c_func(xJPC_BodyFilter_new,{self,fns})
end function

public procedure JPC_BodyFilter_delete(atom obj)
	c_proc(xJPC_BodyFilter_delete,{obj})
end procedure

--ObjectVsBroadPhaseLayerFilter

public constant JPC_ObjectVsBroadPhaseLayerFilterFns = define_c_struct({
	C_POINTER, --shouldCollide
	C_POINTER, --self
	JPC_ObjectLayer, --inLayer1
	JPC_ObjectLayer  --inLayer2
})

public constant xJPC_ObjectVsBroadPhaseLayerFilter_new = define_c_func(jolt,"+JPC_ObjectVsBroadPhaseLayerFilter_new",{C_POINTER,JPC_ObjectVsBroadPhaseLayerFilterFns},C_POINTER),
				xJPC_ObjectVsBroadPhaseLayerFilter_delete = define_c_proc(jolt,"+JPC_ObjectVsBroadPhaseLayerFilter_delete",{C_POINTER})
				
public function JPC_ObjectVsBroadPhaseLayerFilter_new(atom self,sequence fns)
	return c_func(xJPC_ObjectVsBroadPhaseLayerFilter_new,{self,fns})
end function

public procedure JPC_ObjectVsBroadPhaseLayerFilter_delete(atom obj)
	c_proc(xJPC_ObjectVsBroadPhaseLayerFilter_delete,{obj})
end procedure

--ObjectLayerPairFilter

public constant JPC_ObjectLayerPairFilterFns = define_c_struct({
	C_POINTER, --shouldCollide
	C_POINTER, --self
	JPC_ObjectLayer, --inLayer1
	JPC_ObjectLayer  --inLayer2
})

public constant xJPC_ObjectLayerPairFilter_new = define_c_func(jolt,"+JPC_ObjectLayerPairFilter_new",{C_POINTER,JPC_ObjectLayerPairFilterFns},C_POINTER),
				xJPC_ObjectLayerPairFilter_delete = define_c_proc(jolt,"+JPC_ObjectLayerPairFilter_delete",{C_POINTER})
				
public function JPC_ObjectLayerPairFilter_new(atom self,sequence fns)
	return c_func(xJPC_ObjectLayerPairFilter_new,{self,fns})
end function

public procedure JPC_ObjectLayerPairFilter_delete(atom obj)
	c_proc(xJPC_ObjectLayerPairFilter_delete,{obj})
end procedure

--DrawSettings

public constant JPC_BodyManager_DrawSettings = define_c_struct({
	C_BOOL, --DrawGetSupportFunction
	C_BOOL, --DrawSupportDirection
	C_BOOL, --DrawGetSupportingFace
	C_BOOL, --DrawShape
	C_BOOL, --DrawShapeWireFrame
	JPC_ShapeColor, --DrawShapeColor
	C_BOOL, --DrawBoundingBox
	C_BOOL, --DrawCenterOfMassTransform
	C_BOOL, --DrawWorldTransform
	C_BOOL, --DrawVelocity
	C_BOOL, --DrawMassAndInertia
	C_BOOL, --DrawSleepStats
	C_BOOL, --DrawSoftBodyVertices
	C_BOOL, --DrawSoftBodyVertexVelocities
	C_BOOL, --DrawSoftBodyEdgeConstraints
	C_BOOL, --DrawSoftBodyBendConstraints
	C_BOOL, --DrawSoftBodyVolumeConstraints
	C_BOOL, --DrawSoftBodySkinConstraints
	C_BOOL, --DrawSoftBodyLRAConstraints
	C_BOOL  --DrawSoftBodyPredictedBounds
})

public constant xJPC_BodyManager_DrawSettings_default = define_c_proc(jolt,"+JPC_BodyManager_DrawSettings_default",{C_POINTER})

public procedure JPC_BodyManager_DrawSettings_default(atom obj)
	c_proc(xJPC_BodyManager_DrawSettings_default,{obj})
end procedure

--DebugRendererSimple

public constant JPC_DebugRendererSimpleFns = define_c_struct({
	C_POINTER, --drawLine
	C_POINTER, --self
	JPC_RVec3, --inFrom
	JPC_RVec3, --inTo
	JPC_Color --inColor
})

public constant xJPC_DebugRendererSimple_new = define_c_func(jolt,"+JPC_DebugRendererSimple_new",{C_POINTER,JPC_DebugRendererSimpleFns},C_POINTER),
				xJPC_DebugRendererSimple_delete = define_c_proc(jolt,"+JPC_DebugRendererSimple_delete",{C_POINTER})
				
public function JPC_DebugRendererSimple_new(atom self,sequence fns)
	return c_func(xJPC_DebugRendererSimple_new,{self,fns})
end function

public procedure JPC_DebugRendererSimple_delete(atom obj)
	c_proc(xJPC_DebugRendererSimple_delete,{obj})
end procedure

--String

public constant xJPC_String_delete = define_c_proc(jolt,"+JPC_String_delete",{C_STRING}),
				xJPC_String_c_str = define_c_func(jolt,"+JPC_String_c_str",{C_STRING},C_STRING)
				
public procedure JPC_String_delete(sequence self)
	c_proc(xJPC_String_delete,{self})
end procedure

public function JPC_String_c_str(sequence self)
	return c_func(xJPC_String_c_str,{self})
end function

--Shape -> RefTarget

public constant xJPC_Shape_GetRefCount = define_c_func(jolt,"+JPC_Shape_GetRefCount",{C_POINTER},C_UINT32),
				xJPC_Shape_AddRef = define_c_proc(jolt,"+JPC_Shape_AddRef",{C_POINTER}),
				xJPC_Shape_Release = define_c_proc(jolt,"+JPC_Shape_Release",{C_POINTER})
				
public function JPC_Shape_GetRefCount(atom self)
	return c_func(xJPC_Shape_GetRefCount,{self})
end function

public procedure JPC_Shape_AddRef(atom self)
	c_proc(xJPC_Shape_AddRef,{self})
end procedure

public procedure JPC_Shape_Release(atom self)
	c_proc(xJPC_Shape_Release,{self})
end procedure

public constant xJPC_Shape_GetCenterOfMass = define_c_func(jolt,"+JPC_Shape_GetCenterOfMass",{C_POINTER},JPC_Vec3)

public function JPC_Shape_GetCenterOfMass(atom self)
	return c_func(xJPC_Shape_GetCenterOfMass,{self})
end function

--TriangleShapeSettings

public constant JPC_TriangleShapeSettings = define_c_struct({
	C_UINT64, --userData
	C_FLOAT, --density
	JPC_Vec3, --v1
	JPC_Vec3, --v2
	JPC_Vec3, --v3
	C_FLOAT --ConvexRadius
})

public constant xJPC_TriangleShapeSettings_default = define_c_proc(jolt,"+JPC_TriangleShapeSettings_default",{C_POINTER}),
				xJPC_TriangleShapeSettings_Create = define_c_func(jolt,"+JPC_TriangleShapeSettings_Create",{C_POINTER,C_POINTER,C_STRING},C_BOOL)
				
public procedure JPC_TriangleShapeSettings_default(atom obj)
	c_proc(xJPC_TriangleShapeSettings_default,{obj})
end procedure

public function JPC_TriangleShapeSettings_Create(atom self,atom outShape,sequence outError)
	return c_func(xJPC_TriangleShapeSettings_Create,{self,outShape,outError})
end function

--BoxShapeSettings -> ConvexShapeSettings -> ShapeSettings

public constant JPC_BoxShapeSettings = define_c_struct({
	C_UINT64, --userData
	C_FLOAT, --density
	JPC_Vec3, --HalfExtent
	C_FLOAT --ConvexRadius
})

public constant xJPC_BoxShapeSettings_default = define_c_proc(jolt,"+JPC_BoxShapeSettings_default",{C_POINTER}),
				xJPC_BoxShapeSettings_Create = define_c_func(jolt,"+JPC_BoxShapeSettings_Create",{C_POINTER,C_POINTER,C_STRING},C_BOOL)
				
public procedure JPC_BoxShapeSettings_default(atom obj)
	c_proc(xJPC_BoxShapeSettings_default,{obj})
end procedure

public function JPC_BoxShapeSettings_Create(atom self,atom outShape,sequence outError)
	return c_func(xJPC_BoxShapeSettings_Create,{self,outShape,outError})
end function

--SphereShapeSettings -> ConvexShapeSettings -> ShapeSettings

public constant JPC_SphereShapeSettings = define_c_struct({
	C_UINT64, --userData [1]
	C_FLOAT, --density [2]
	C_FLOAT --radius [3]
})

public constant xJPC_SphereShapeSettings_default = define_c_proc(jolt,"+JPC_ShpereShapeSettings_default",{C_POINTER}),
				xJPC_SphereShapeSettings_Create = define_c_func(jolt,"+JPC_SphereShapeSettings_Create",{C_POINTER,C_POINTER,C_STRING},C_BOOL)
				
public procedure JPC_SphereShapeSettings_default(atom obj)
	c_proc(xJPC_SphereShapeSettings_default,{obj})
end procedure

public function JPC_SphereShapeSettings_Create(atom self,atom outShape,sequence outError)
	return c_func(xJPC_SphereShapeSettings_Create,{self,outShape,outError})
end function

--CapsuleShapeSettings -> ConvexShapeSettings -> ShapeSettings
public constant JPC_CapsuleShapeSettings = define_c_struct({
	C_UINT64, --userData
	C_FLOAT, --density
	C_FLOAT, --Radius
	C_FLOAT  --HalfHeightOfCylinder
})

public constant xJPC_CapsuleShapeSettings_default = define_c_proc(jolt,"+JPC_CapsuleShapeSettings_default",{C_POINTER}),
				xJPC_CapsuleShapeSettings_Create = define_c_func(jolt,"+JPC_CapsuleShapeSettings_Create",{C_POINTER,C_POINTER,C_STRING},C_BOOL)
				
public procedure JPC_CapsuleShapeSettings_default(atom obj)
	c_proc(xJPC_CapsuleShapeSettings_default,{obj})
end procedure

public function JPC_CapsuleShapeSettings_Create(atom self,atom outShape,sequence outError)
	return c_func(xJPC_CapsuleShapeSettings_Create,{self,outShape,outError})
end function

--CylinderShapeSettings -> ConvexShapeSettings -> ShapeSettings

public constant JPC_CylinderShapeSettings = define_c_struct({
	C_UINT64, --userData
	C_FLOAT, --density
	C_FLOAT, --HalfHeight
	C_FLOAT, --Radius
	C_FLOAT --ConvexRadius
})

public constant xJPC_CylinderShapeSettings_default = define_c_proc(jolt,"+JPC_CylinderShapeSettings_default",{C_POINTER}),
				xJPC_CylinderShapeSettings_Create = define_c_func(jolt,"+JPC_CylinderShapeSettings_Create",{C_POINTER,C_POINTER,C_STRING},C_BOOL)
				
public procedure JPC_CylinderShapeSettings_default(atom obj)
	c_proc(xJPC_CylinderShapeSettings_default,{obj})
end procedure

public function JPC_CylinderShapeSettings_Create(atom self,atom outShape,sequence outError)
	return c_func(xJPC_CylinderShapeSettings_Create,{self,outShape,outError})
end function

--ConvexHullShapeSettings -> ConvexShapeSettings -> ShapeSettings

public constant JPC_ConvexHullShapeSettings = define_c_struct({
	C_UINT64, --userData
	C_FLOAT, --density
	C_POINTER, --points JPC_Vec3*
	C_SIZE_T, --PointsLen
	C_FLOAT, --MaxConvexRadius
	C_FLOAT, --MaxErrorConvexRadius
	C_FLOAT --HullTolerance
})

public constant xJPC_ConvexHullShapeSettings_default = define_c_proc(jolt,"+JPC_ConvexHullShapeSettings_default",{C_POINTER}),
				xJPC_ConvexHullShapeSettings_Create = define_c_func(jolt,"+JPC_ConvexHullShapeSettings_Create",{C_POINTER,C_POINTER,C_STRING},C_BOOL)
				
public procedure JPC_ConvexHullShapeSettings_default(atom obj)
	c_proc(xJPC_ConvexHullShapeSettings_default,{obj})
end procedure

public function JPC_ConvexHullShapeSettings_Create(atom self,atom outShape,sequence outError)
	return c_func(xJPC_ConvexHullShapeSettings_Create,{self,outShape,outError})
end function

--CompoundShape:SubShapeSettings

public constant JPC_SubShapeSettings = define_c_struct({
	C_POINTER, --shape JPC_Shape*
	JPC_Vec3, --Position
	JPC_Quat, --Rotation
	C_UINT32 --userDAta
})

public constant xJPC_SubShapeSettings_default = define_c_proc(jolt,"+JPC_SubShapeSettings_default",{C_POINTER})

public procedure JPC_SubShapeSettings_default(atom obj)
	c_proc(xJPC_SubShapeSettings_default,{obj})
end procedure

--StaticCompoundShapeSettings -> CompoundShapeSettings -> ShapeSettings

public constant JPC_StaticCompoundShapeSettings = define_c_struct({
	C_UINT64, --userData
	C_POINTER, --SubShapes
	C_SIZE_T --SubShapesLen
})

public constant xJPC_StaticCompoundShapeSettings_default = define_c_proc(jolt,"+JPC_StaticCompoundShapeSettings_default",{C_POINTER}),
				xJPC_StaticCompoundShapeSettings_Create = define_c_func(jolt,"+JPC_StaticCompoundShapeSettings_Create",{C_POINTER,C_POINTER,C_STRING},C_BOOL)
				
public procedure JPC_StaticCompoundShapeSettings_default(atom obj)
	c_proc(xJPC_StaticCompoundShapeSettings_default,{obj})
end procedure

public function JPC_StaticCompoundShapeSettings_Create(atom self,atom outShape,sequence outError)
	return c_func(xJPC_StaticCompoundShapeSettings_Create,{self,outShape,outError})
end function

--MutableCompoundShape -> CompoundShapeSettings -> ShapeSettings

public constant JPC_MutableCompoundShapeSettings = define_c_struct({
	C_UINT64, --userData
	C_POINTER, --SubShapes JPC_SubShapeSettings*
	C_SIZE_T --SubShapesLen
})

public constant xJPC_MutableCompoundShapeSettings_default = define_c_proc(jolt,"+JPC_MutableCompoundShapeSettings_default",{C_POINTER}),
				xJPC_MutableCompoundShapeSettings_Create = define_c_func(jolt,"+JPC_MutableCompoundShapeSettings_Create",{C_POINTER,C_POINTER,C_STRING},C_BOOL)
				
public procedure JPC_MutableCompoundShapeSettings_default(atom obj)
	c_proc(xJPC_MutableCompoundShapeSettings_default,{obj})
end procedure

public function JPC_MutableCompoundShapeSettings_Create(atom self,atom outShape,sequence outError)
	return c_func(xJPC_MutableCompoundShapeSettings_Create,{self,outShape,outError})
end function

--BodyCreationSettings

public constant JPC_BodyCreationSettings = define_c_struct({
	JPC_RVec3, --Position [1]
	JPC_Quat, --Rotation [2]
	JPC_Vec3, --LinearVelocity [3]
	JPC_Vec3, --AngularVelocity [4]
	C_UINT64, --userDAta [5]
	JPC_ObjectLayer, --objectLayer [6]
	C_INT, --MotionType JPC_MotionType [7]
	C_INT, --AllowedDOFs JPC_AllowedDOFs [8]
	C_BOOL, --AllowDynamicOrKinematic [9]
	C_BOOL, --IsSensor [10]
	C_BOOL, --CollideKinematicVsNonDynamic [11]
	C_BOOL, --UseMainifoldReduction [12]
	C_BOOL, --ApplyGyroscopicForce [13]
	C_INT, --MotionQuality JPC_MotionQuality [14]
	C_BOOL, --EnhancedInternalEdgeRemoval [15]
	C_BOOL, --AllowSleeping [16]
	C_FLOAT, --Friction [17]
	C_FLOAT, --Restitution [18]
	C_FLOAT, --LinearDamping [19]
	C_FLOAT, --AngularDamping [20]
	C_FLOAT, --MaxLinearVelocity [21]
	C_FLOAT, --MaxAngularVelocity [22]
	C_FLOAT, --GravityFactor [23]
	C_UINT, --NumVelocityStepsOverride [24]
	C_UINT, --NumPositionStepsOverride [25]
	C_INT, --OverrideMassProperties JPC_OverrideMassProperties [26]
	C_FLOAT, --IntertialMultiplier [27]
	C_POINTER --Shape JPC_Shape* [28]
})

public constant xJPC_BodyCreationSettings_default = define_c_proc(jolt,"+JPC_BodyCreationSettings_default",{C_POINTER})

public procedure JPC_BodyCreationSettings_default(atom settings)
	c_proc(xJPC_BodyCreationSettings_default,{settings})
end procedure

public constant xJPC_BodyCreationSettings_new = define_c_func(jolt,"+JPC_BodyCreationSettings_new",{},C_POINTER)

public function JPC_BodyCreationSettings_new()
	return c_func(xJPC_BodyCreationSettings_new,{})
end function

--Body

public constant xJPC_Body_GetID = define_c_func(jolt,"+JPC_Body_GetID",{C_POINTER},JPC_BodyID),
				xJPC_Body_GetBodyType = define_c_func(jolt,"+JPC_Body_GetBodyType",{C_POINTER},C_INT),
				xJPC_Body_IsRigidBody = define_c_func(jolt,"+JPC_Body_IsRigidBody",{C_POINTER},C_BOOL),
				xJPC_Body_IsSoftBody = define_c_func(jolt,"+JPC_Body_IsSoftBody",{C_POINTER},C_BOOL),
				xJPC_Body_IsActive = define_c_func(jolt,"+JPC_Body_IsActive",{C_POINTER},C_BOOL),
				xJPC_Body_IsStatic = define_c_func(jolt,"+JPC_Body_IsStatic",{C_POINTER},C_BOOL),
				xJPC_Body_IsKinematic = define_c_func(jolt,"+JPC_Body_IsKinematic",{C_POINTER},C_BOOL),
				xJPC_Body_IsDynamic = define_c_func(jolt,"+JPC_Body_IsDynamic",{C_POINTER},C_BOOL),
				xJPC_Body_CanBeKinematicOrDynamic = define_c_func(jolt,"+JPC_Body_CanBeKinematicOrDynamic",{C_POINTER},C_BOOL),
				xJPC_Body_SetIsSensor = define_c_proc(jolt,"+JPC_Body_SetIsSensor",{C_POINTER,C_BOOL}),
				xJPC_Body_IsSensor = define_c_func(jolt,"+JPC_Body_IsSensor",{C_POINTER},C_BOOL),
				xJPC_Body_SetCollideKinematicVsNonDynamic = define_c_proc(jolt,"+JPC_Body_SetCollideKinematicVsNonDynamic",{C_POINTER,C_BOOL}),
				xJPC_Body_GetCollideKinematicVsNonDynamic = define_c_func(jolt,"+JPC_Body_GetCollideKinematicVsNonDynamic",{C_POINTER},C_BOOL),
				xJPC_Body_SetUseManifoldReduction = define_c_proc(jolt,"+JPC_Body_SetUseManifoldReduction",{C_POINTER,C_BOOL}),
				xJPC_Body_GetUseManifoldReduction = define_c_func(jolt,"+JPC_Body_GetUseManifoldReduction",{C_POINTER},C_BOOL),
				xJPC_Body_GetUseManifoldReductionWithBody = define_c_func(jolt,"+JPC_Body_GetUseManifoldReductionWithBody",{C_POINTER,C_POINTER},C_BOOL),
				xJPC_Body_SetApplyGyroscopicForce = define_c_proc(jolt,"+JPC_Body_SetApplyGyroscopicForce",{C_POINTER,C_BOOL}),
				xJPC_Body_GetApplyGyroscopicForce = define_c_func(jolt,"+JPC_Body_GetApplyGyroscopicForce",{C_POINTER},C_BOOL),
				xJPC_Body_SetEnhancedInternalEdgeRemoval = define_c_proc(jolt,"+JPC_Body_SetEnhancedInternalEdgeRemoval",{C_POINTER,C_BOOL}),
				xJPC_Body_GetEnhancedInternalEdgeRemoval = define_c_func(jolt,"+JPC_Body_GetEnhancedInternalEdgeRemoval",{C_POINTER},C_BOOL),
				xJPC_Body_GetEnhancedInternalEdgeRemovalWithBody = define_c_func(jolt,"+JPC_Body_GetEnhancedInternalEdgeRemovalWithBody",{C_POINTER,C_POINTER},C_BOOL),
				xJPC_Body_GetMotionType = define_c_func(jolt,"+JPC_Body_GetMotionType",{C_POINTER},C_INT),
				xJPC_Body_SetMotionType = define_c_proc(jolt,"+JPC_Body_SetMotionType",{C_POINTER,C_INT}),
				xJPC_Body_GetBroadPhaseLayer = define_c_func(jolt,"+JPC_Body_GetBroadPhaseLayer",{C_POINTER},JPC_BroadPhaseLayer),
				xJPC_Body_GetObjectLayer = define_c_func(jolt,"+JPC_Body_GetObjectLayer",{C_POINTER},JPC_ObjectLayer)
				
public function JPC_Body_GetID(atom self)
	return c_func(xJPC_Body_GetID,{self})
end function

public function JPC_Body_GetBodyType(atom self)
	return c_func(xJPC_Body_GetBodyType,{self})
end function

public function JPC_Body_IsRigidBody(atom self)
	return c_func(xJPC_Body_IsRigidBody,{self})
end function

public function JPC_Body_IsSoftBody(atom self)
	return c_func(xJPC_Body_IsSoftBody,{self})
end function

public function JPC_Body_IsActive(atom self)
	return c_func(xJPC_Body_IsActive,{self})
end function

public function JPC_Body_IsStatic(atom self)
	return c_func(xJPC_Body_IsStatic,{self})
end function

public function JPC_Body_IsKinematic(atom self)
	return c_func(xJPC_Body_IsKinematic,{self})
end function

public function JPC_Body_IsDynamic(atom self)
	return c_func(xJPC_Body_IsDynamic,{self})
end function

public function JPC_Body_CanBeKinematicOrDynamic(atom self)
	return c_func(xJPC_Body_CanBeKinematicOrDynamic,{self})
end function

public procedure JPC_Body_SetIsSensor(atom self,atom isSensor)
	c_proc(xJPC_Body_SetIsSensor,{self,isSensor})
end procedure

public function JPC_Body_IsSensor(atom self)
	return c_func(xJPC_Body_IsSensor,{self})
end function

public procedure JPC_Body_SetCollideKinematicVsNonDynamic(atom self,atom inCollide)
	c_proc(xJPC_Body_SetCollideKinematicVsNonDynamic,{self,inCollide})
end procedure

public function JPC_Body_GetCollideKinematicVsNonDynamic(atom self)
	return c_func(xJPC_Body_GetCollideKinematicVsNonDynamic,{self})
end function

public procedure JPC_Body_SetUseManifoldReduction(atom self,atom inUseReduction)
	c_proc(xJPC_Body_SetUseManifoldReduction,{self,inUseReduction})
end procedure

public function JPC_Body_GetUseManifoldReduction(atom self)
	return c_func(xJPC_Body_GetUseManifoldReduction,{self})
end function

public function JPC_Body_GetUseManifoldReductionWithBody(atom self,atom inBody2)
	return c_func(xJPC_Body_GetUseManifoldReductionWithBody,{self,inBody2})
end function

public procedure JPC_Body_SetApplyGyroscopicForce(atom self,atom inApply)
	c_proc(xJPC_Body_SetApplyGyroscopicForce,{self,inApply})
end procedure

public function JPC_Body_GetApplyGyroscopicForce(atom self)
	return c_func(xJPC_Body_GetApplyGyroscopicForce,{self})
end function

public procedure JPC_Body_SetEnhancedInternalEdgeRemoval(atom self,atom inApply)
	c_proc(xJPC_Body_SetEnhancedInternalEdgeRemoval,{self,inApply})
end procedure

public function JPC_Body_GetEnhancedInternalEdgeRemoval(atom self)
	return c_func(xJPC_Body_GetEnhancedInternalEdgeRemoval,{self})
end function

public function JPC_Body_GetEnhancedInternalEdgeRemovalWithBody(atom self,atom inBody2)
	return c_func(xJPC_Body_GetEnhancedInternalEdgeRemovalWithBody,{self,inBody2})
end function

public function JPC_Body_GetMotionType(atom self)
	return c_func(xJPC_Body_GetMotionType,{self})
end function

public procedure JPC_Body_SetMotionType(atom self,JPC_MotionType inMotionType)
	c_proc(xJPC_Body_SetMotionType,{self,inMotionType})
end procedure

public function JPC_Body_GetBroadPhaseLayer(atom self)
	return c_func(xJPC_Body_GetBroadPhaseLayer,{self})
end function

public function JPC_Body_GetObjectLayer(atom self)
	return c_func(xJPC_Body_GetObjectLayer,{self})
end function

public constant xJPC_Body_GetAllowSleeping = define_c_func(jolt,"+JPC_Body_GetAllowSleeping",{C_POINTER},C_BOOL),
				xJPC_Body_SetAllowSleeping = define_c_proc(jolt,"+JPC_Body_SetAllowSleeping",{C_POINTER,C_BOOL}),
				xJPC_Body_ResetSleepTimer = define_c_proc(jolt,"+JPC_Body_ResetSleepTimer",{C_POINTER}),
				xJPC_Body_GetFriction = define_c_func(jolt,"+JPC_Body_GetFriction",{C_POINTER},C_FLOAT),
				xJPC_Body_SetFriction = define_c_proc(jolt,"+JPC_Body_SetFriction",{C_POINTER,C_FLOAT}),
				xJPC_Body_GetRestitution = define_c_func(jolt,"+JPC_Body_GetRestitution",{C_POINTER},C_FLOAT),
				xJPC_Body_SetRestitution = define_c_proc(jolt,"+JPC_Body_SetRestitution",{C_POINTER,C_FLOAT}),
				xJPC_Body_GetLinearVelocity = define_c_func(jolt,"+JPC_Body_GetLinearVelocity",{C_POINTER},JPC_Vec3),
				xJPC_Body_SetLinearVelocity = define_c_proc(jolt,"+JPC_Body_SetLinearVelocity",{C_POINTER,JPC_Vec3}),
				xJPC_Body_SetLinearVelocityClamped = define_c_proc(jolt,"+JPC_Body_SetLinearVelocityClamped",{C_POINTER,JPC_Vec3}),
				xJPC_Body_GetAngularVelocity = define_c_func(jolt,"+JPC_Body_GetAngularVelocity",{C_POINTER},JPC_Vec3),
				xJPC_Body_SetAngularVelocity = define_c_proc(jolt,"+JPC_Body_SetAngularVelocity",{C_POINTER,JPC_Vec3}),
				xJPC_Body_SetAngularVelocityClamped = define_c_proc(jolt,"+JPC_Body_SetAngularVelocityClamped",{C_POINTER,JPC_Vec3}),
				xJPC_Body_GetPointVelocityCOM = define_c_func(jolt,"+JPC_Body_GetPointVelocityCOM",{C_POINTER,JPC_Vec3},JPC_Vec3),
				xJPC_Body_GetPointVelocity = define_c_func(jolt,"+JPC_Body_GetPointVelocity",{C_POINTER,JPC_RVec3},JPC_Vec3),
				xJPC_Body_AddForce = define_c_proc(jolt,"+JPC_Body_AddForce",{C_POINTER,JPC_Vec3})
				
public function JPC_Body_GetAllowSleeping(atom self)
	return c_func(xJPC_Body_GetAllowSleeping,{self})
end function

public procedure JPC_Body_SetAllowSleeping(atom self,atom inAllow)
	c_proc(xJPC_Body_SetAllowSleeping,{self,inAllow})
end procedure

public procedure JPC_Body_ResetSleepTimer(atom self)
	c_proc(xJPC_Body_ResetSleepTimer,{self})
end procedure

public function JPC_Body_GetFriction(atom self)
	return c_func(xJPC_Body_GetFriction,{self})
end function

public procedure JPC_Body_SetFriction(atom self,atom inFriction)
	c_proc(xJPC_Body_SetFriction,{self,inFriction})
end procedure

public function JPC_Body_GetRestitution(atom self)
	return c_func(xJPC_Body_GetRestitution,{self})
end function

public procedure JPC_Body_SetRestitution(atom self,atom inRestitution)
	c_proc(xJPC_Body_SetRestitution,{self,inRestitution})
end procedure

public function JPC_Body_GetLinearVelocity(atom self)
	return c_func(xJPC_Body_GetLinearVelocity,{self})
end function

public procedure JPC_Body_SetLinearVelocity(atom self,sequence inLinearVelocity)
	c_proc(xJPC_Body_SetLinearVelocity,{self,inLinearVelocity}) --JPC_Vec3
end procedure

public procedure JPC_Body_SetLinearVelocityClamped(atom self,sequence inLinearVelocity)
	c_proc(xJPC_Body_SetLinearVelocityClamped,{self,inLinearVelocity}) --JPC_Vec3
end procedure

public function JPC_Body_GetAngularVelocity(atom self)
	return c_func(xJPC_Body_GetAngularVelocity,{self})
end function

public procedure JPC_Body_SetAngularVelocity(atom self,sequence inAngularVelocity)
	c_proc(xJPC_Body_SetAngularVelocity,{self,inAngularVelocity}) --JPC_Vec3
end procedure

public procedure JPC_Body_SetAngularVelocityClamped(atom self,sequence inAngularVelocity)
	c_proc(xJPC_Body_SetAngularVelocityClamped,{self,inAngularVelocity}) --JPC_Vec3
end procedure

public function JPC_Body_GetPointVelocityCOM(atom self,sequence PointRelativeToCom)
	return c_func(xJPC_Body_GetPointVelocityCOM,{self,PointRelativeToCom}) --JPC_Vec3
end function

public function JPC_Body_GetPointVelocity(atom self,sequence inPoint)
	return c_func(xJPC_Body_GetPointVelocity,{self,inPoint}) --JPC_RVec3
end function

public procedure JPC_Body_AddForce(atom self,sequence inForce)
	c_proc(xJPC_Body_AddForce,{self,inForce})
end procedure

public constant xJPC_Body_AddTorque = define_c_proc(jolt,"+JPC_Body_AddTorque",{C_POINTER,JPC_Vec3}),
				xJPC_Body_GetAccumulatedForce = define_c_func(jolt,"+JPC_Body_GetAccumulatedForce",{C_POINTER},JPC_Vec3),
				xJPC_Body_GetAccumulatedTorque = define_c_func(jolt,"+JPC_Body_GetAccumulatedTorque",{C_POINTER},JPC_Vec3),
				xJPC_Body_ResetForce = define_c_proc(jolt,"+JPC_Body_ResetForce",{C_POINTER}),
				xJPC_Body_ResetTorque = define_c_proc(jolt,"+JPC_Body_ResetTorque",{C_POINTER}),
				xJPC_Body_ResetMotion = define_c_proc(jolt,"+JPC_Body_ResetMotion",{C_POINTER}),
				xJPC_Body_GetInverseInertia = define_c_proc(jolt,"+JPC_Body_GetInverseInertia",{C_POINTER,C_POINTER}),
				xJPC_Body_AddImpulse = define_c_proc(jolt,"+JPC_Body_AddImpulse",{C_POINTER,JPC_Vec3}),
				xJPC_Body_AddImpulse2 = define_c_proc(jolt,"+JPC_Body_AddImpulse2",{C_POINTER,JPC_Vec3,JPC_RVec3}),
				xJPC_Body_AddAngularImpulse = define_c_proc(jolt,"+JPC_Body_AddAngularImpulse",{C_POINTER,JPC_Vec3}),
				xJPC_Body_MoveKinematic = define_c_proc(jolt,"+JPC_Body_MoveKinematic",{C_POINTER,JPC_RVec3,JPC_Quat,C_FLOAT}),
				xJPC_Body_ApplyBuoyancyImpulse = define_c_func(jolt,"+JPC_Body_ApplyBuoyancyImpulse",{C_POINTER,JPC_RVec3,JPC_Vec3,C_FLOAT,C_FLOAT,C_FLOAT,JPC_Vec3,JPC_Vec3,C_FLOAT},C_BOOL),
				xJPC_Body_IsInBroadPhase = define_c_func(jolt,"+JPC_Body_IsInBroadPhase",{C_POINTER},C_BOOL),
				xJPC_Body_IsCollisionCacheInvalid = define_c_func(jolt,"+JPC_Body_IsCollisionCacheInvalid",{C_POINTER},C_BOOL),
				xJPC_Body_GetShape = define_c_func(jolt,"+JPC_Body_GetShape",{C_POINTER},C_POINTER),
				xJPC_Body_GetPosition = define_c_func(jolt,"+JPC_Body_GetPosition",{C_POINTER},JPC_RVec3),
				xJPC_Body_GetRotation = define_c_func(jolt,"+JPC_Body_GetRotation",{C_POINTER},JPC_Quat)
				
public procedure JPC_Body_AddTorque(atom self,sequence inTorque)
	c_proc(xJPC_Body_AddTorque,{self,inTorque})
end procedure

public function JPC_Body_GetAccumulatedForce(atom self)
	return c_func(xJPC_Body_GetAccumulatedForce,{self})
end function

public function JPC_Body_GetAccumulatedTorque(atom self)
	return c_func(xJPC_Body_GetAccumulatedTorque,{self})
end function

public procedure JPC_Body_ResetForce(atom self)
	c_proc(xJPC_Body_ResetForce,{self})
end procedure

public procedure JPC_Body_ResetTorque(atom self)
	c_proc(xJPC_Body_ResetTorque,{self})
end procedure

public procedure JPC_Body_ResetMotion(atom self)
	c_proc(xJPC_Body_ResetMotion,{self})
end procedure

public procedure JPC_Body_GetInverseInertia(atom self,atom outMatrix)
	c_proc(xJPC_Body_GetInverseInertia,{self,outMatrix})
end procedure

public procedure JPC_Body_AddImpulse(atom self,sequence inImpulse)
	c_proc(xJPC_Body_AddImpulse,{self,inImpulse})
end procedure

public procedure JPC_Body_AddImpulse2(atom self,sequence inImpulse,sequence inPosition)
	c_proc(xJPC_Body_AddImpulse2,{self,inImpulse,inPosition})
end procedure

public procedure JPC_Body_AddAngularImpulse(atom self,sequence AngularImp)
	c_proc(xJPC_Body_AddAngularImpulse,{self,AngularImp})
end procedure

public procedure JPC_Body_MoveKinematic(atom self,sequence TargetPos,sequence TargetRot,atom DeltaTime)
	c_proc(xJPC_Body_MoveKinematic,{self,TargetPos,TargetRot,DeltaTime})
end procedure

public function JPC_Body_ApplyBuoyancyImpulse(atom self,sequence SurfacePos,sequence SurfaceNorm,atom inBuoyancy,atom LinearDrag,atom AngularDrag,sequence FluidVelocity,sequence inGravity,atom DeltaTime)
	return c_func(xJPC_Body_ApplyBuoyancyImpulse,{self,SurfacePos,SurfaceNorm,inBuoyancy,LinearDrag,AngularDrag,FluidVelocity,inGravity,DeltaTime})
end function

public function JPC_Body_IsInBroadPhase(atom self)
	return c_func(xJPC_Body_IsInBroadPhase,{self})
end function

public function JPC_Body_IsCollisionCacheInvalid(atom self)
	return c_func(xJPC_Body_IsCollisionCacheInvalid,{self})
end function

public function JPC_Body_GetShape(atom self)
	return c_func(xJPC_Body_GetShape,{self})
end function

public function JPC_Body_GetPosition(atom self)
	return c_func(xJPC_Body_GetPosition,{self})
end function

public function JPC_Body_GetRotation(atom self)
	return c_func(xJPC_Body_GetRotation,{self})
end function

public constant xJPC_Body_GetCenterOfMassPosition = define_c_func(jolt,"+JPC_Body_GetCenterOfMassPosition",{C_POINTER},JPC_RVec3)

public function JPC_Body_GetCenterOfMassPosition(atom self)
	return c_func(xJPC_Body_GetCenterOfMassPosition,{self})
end function

public constant xJPC_Body_GetUserData = define_c_func(jolt,"+JPC_Body_GetUserData",{C_POINTER},C_UINT64),
				xJPC_Body_SetUserData = define_c_proc(jolt,"+JPC_Body_SetUserData",{C_POINTER,C_UINT64})
				
public function JPC_Body_GetUserData(atom self)
	return c_func(xJPC_Body_GetUserData,{self})
end function

public procedure JPC_Body_SetUserData(atom self,atom userData)
	c_proc(xJPC_Body_SetUserData,{self,userData})
end procedure

public constant xJPC_BodyInterface_CreateBody = define_c_func(jolt,"+JPC_BodyInterface_CreateBody",{C_POINTER,C_POINTER},C_POINTER),
				xJPC_BodyInterface_CreateBodyWithID = define_c_func(jolt,"+JPC_BodyInterface_CreateBodyWithID",{C_POINTER,JPC_BodyID,C_POINTER},C_POINTER),
				xJPC_BodyInterface_CreateBodyWithoutID = define_c_func(jolt,"+JPC_BodyInterface_CreateBodyWithoutID",{C_POINTER,C_POINTER},C_POINTER)
				
public function JPC_BodyInterface_CreateBody(atom self,atom inSettings)
	return c_func(xJPC_BodyInterface_CreateBody,{self,inSettings})
end function

public function JPC_BodyInterface_CreateBodyWithID(atom self,atom bodyID,atom inSettings)
	return c_func(xJPC_BodyInterface_CreateBodyWithID,{self,bodyID,inSettings})
end function

public function JPC_BodyInterface_CreateBodyWithoutID(atom self,atom inSettings)
	return c_func(xJPC_BodyInterface_CreateBodyWithoutID,{self,inSettings})
end function

public constant xJPC_BodyInterface_DestroyBodyWithoutID = define_c_proc(jolt,"+JPC_BodyInterface_DestroyBodyWithoutID",{C_POINTER,C_POINTER}),
				xJPC_BodyInterface_AssignBodyID = define_c_func(jolt,"+JPC_BodyInterface_AssignBodyID",{C_POINTER,C_POINTER},C_BOOL)
				
public procedure JPC_BodyInterface_DestroyBodyWithoutID(atom self,atom inBody)
	c_proc(xJPC_BodyInterface_DestroyBodyWithoutID,{self,inBody})
end procedure

public function JPC_BodyInterface_AssignBodyID(atom self,atom ioBody)
	return c_func(xJPC_BodyInterface_AssignBodyID,{self,ioBody})
end function

public constant xJPC_BodyInterface_UnassignBodyID = define_c_func(jolt,"+JPC_BodyInterface_UnassignBodyID",{C_POINTER,JPC_BodyID},C_POINTER),
				xJPC_BodyInterface_UnassignBodyIDs = define_c_proc(jolt,"+JPC_BodyInterface_UnassignBodyIDs",{C_POINTER,C_POINTER,C_INT,C_POINTER}),
				xJPC_BodyInterface_DestroyBody = define_c_proc(jolt,"+JPC_BodyInterface_DestroyBody",{C_POINTER,JPC_BodyID}),
				xJPC_BodyInterface_DestroyBodies = define_c_proc(jolt,"+JPC_BodyInterface_DestroyBodies",{C_POINTER,C_POINTER,C_INT}),
				xJPC_BodyInterface_AddBody = define_c_proc(jolt,"+JPC_BodyInterface_AddBody",{C_POINTER,JPC_BodyID,C_INT}),
				xJPC_BodyInterface_RemoveBody = define_c_proc(jolt,"+JPC_BodyInterface_RemoveBody",{C_POINTER,JPC_BodyID}),
				xJPC_BodyInterface_IsAdded = define_c_func(jolt,"+JPC_BodyInterface_IsAdded",{C_POINTER,JPC_BodyID},C_BOOL),
				xJPC_BodyInterface_CreateAndAddBody = define_c_func(jolt,"+JPC_BodyInterface_CreateAndAddBody",{C_POINTER,C_POINTER,C_INT},JPC_BodyID)
				
public function JPC_BodyInterface_UnassignBodyID(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_UnassignBodyID,{self,bodyID})
end function

public procedure JPC_BodyInterface_UnassignBodyIDs(atom self,atom bodyIDs,atom num,atom outBodies)
	c_proc(xJPC_BodyInterface_UnassignBodyIDs,{self,bodyIDs,num,outBodies})
end procedure

public procedure JPC_BodyInterface_DestroyBody(atom self,atom bodyID)
	c_proc(xJPC_BodyInterface_DestroyBody,{self,bodyID})
end procedure

public procedure JPC_BodyInterface_DestroyBodies(atom self,atom bodyIDs,atom num)
	c_proc(xJPC_BodyInterface_DestroyBodies,{self,bodyIDs,num})
end procedure

public procedure JPC_BodyInterface_AddBody(atom self,atom bodyID,JPC_Activation actmode)
	c_proc(xJPC_BodyInterface_AddBody,{self,bodyID,actmode})
end procedure

public procedure JPC_BodyInterface_RemoveBody(atom self,atom bodyID)
	c_proc(xJPC_BodyInterface_RemoveBody,{self,bodyID})
end procedure

public function JPC_BodyInterface_IsAdded(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_IsAdded,{self,bodyID})
end function

public function JPC_BodyInterface_CreateAndAddBody(atom self,atom inSettings,JPC_Activation actmode)
	return c_func(xJPC_BodyInterface_CreateAndAddBody,{self,inSettings,actmode})
end function

public constant xJPC_BodyInterface_AddBodiesPrepare = define_c_func(jolt,"+JPC_BodyInterface_AddBodiesPrepare",{C_POINTER,C_POINTER,C_INT},C_POINTER),
				xJPC_BodyInterface_AddBodiesFinalize = define_c_proc(jolt,"+JPC_BodyInterface_AddBodiesFinalize",{C_POINTER,C_POINTER,C_INT,C_POINTER,C_INT}),
				xJPC_BodyInterface_AddBodiesAbort = define_c_proc(jolt,"+JPC_BodyInterface_AddBodiesAbort",{C_POINTER,C_POINTER,C_INT,C_POINTER}),
				xJPC_BodyInterface_RemoveBodies = define_c_proc(jolt,"+JPC_BodyInterface_RemoveBodies",{C_POINTER,C_POINTER,C_INT}),
				xJPC_BodyInterface_ActivateBody = define_c_proc(jolt,"+JPC_BodyInterface_ActivateBody",{C_POINTER,JPC_BodyID}),
				xJPC_BodyInterface_ActivateBodies = define_c_proc(jolt,"+JPC_BodyInterface_ActivateBodies",{C_POINTER,C_POINTER,C_INT})
				
public function JPC_BodyInterface_AddBodiesPrepare(atom self,atom ioBodies,atom Num)
	return c_func(xJPC_BodyInterface_AddBodiesPrepare,{self,ioBodies,Num})
end function

public procedure JPC_BodyInterface_AddBodiesFinalize(atom self,atom ioBodies,atom Num,atom AddState,JPC_Activation actmode)
	c_proc(xJPC_BodyInterface_AddBodiesFinalize,{self,ioBodies,Num,AddState,actmode})
end procedure

public procedure JPC_BodyInterface_AddBodiesAbort(atom self,atom ioBodies,atom Num,atom AddState)
	c_proc(xJPC_BodyInterface_AddBodiesAbort,{self,ioBodies,Num,AddState})
end procedure

public procedure JPC_BodyInterface_RemoveBodies(atom self,atom ioBodies,atom Num)
	c_proc(xJPC_BodyInterface_RemoveBodies,{self,ioBodies,Num})
end procedure

public procedure JPC_BodyInterface_ActivateBody(atom self,atom bodyID)
	c_proc(xJPC_BodyInterface_ActivateBody,{self,bodyID})
end procedure

public procedure JPC_BodyInterface_ActivateBodies(atom self,atom BodyIDs,atom Num)
	c_proc(xJPC_BodyInterface_ActivateBodies,{self,BodyIDs,Num})
end procedure

public constant xJPC_BodyInterface_DeactivateBody = define_c_proc(jolt,"+PC_BodyInterface_DeactivateBody",{C_POINTER,JPC_BodyID}),
				xJPC_BodyInterface_DeactivateBodies = define_c_proc(jolt,"+JPC_BodyInterface_DeactivateBodies",{C_POINTER,C_POINTER,C_INT}),
				xJPC_BodyInterface_IsActive = define_c_func(jolt,"+JPC_BodyInterface_IsActive",{C_POINTER,JPC_BodyID},C_BOOL)
				
public procedure JPC_BodyInterface_DeactivateBody(atom self,atom bodyID)
	c_proc(xJPC_BodyInterface_DeactivateBody,{self,bodyID})
end procedure

public procedure JPC_BodyInterface_DeactivateBodies(atom self,atom bodyIDs,atom Num)
	c_proc(xJPC_BodyInterface_DeactivateBodies,{self,bodyIDs,Num})
end procedure

public function JPC_BodyInterface_IsActive(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_IsActive,{self,bodyID})
end function

public constant xJPC_BodyInterface_SetShape = define_c_proc(jolt,"+JPC_BodyInterface_SetShape",{C_POINTER,JPC_BodyID,C_POINTER,C_BOOL,C_INT})

public procedure JPC_BodyInterface_SetShape(atom self,atom bodyID,atom shape,atom updateMassProp,JPC_Activation actmode)
	c_proc(xJPC_BodyInterface_SetShape,{self,bodyID,shape,updateMassProp,actmode})
end procedure

public constant xJPC_BodyInterface_NotifyShapeChanged = define_c_proc(jolt,"+JPC_BodyInterface_NotifyShapeChanged",{C_POINTER,JPC_BodyID,JPC_Vec3,C_BOOL,C_INT})

public procedure JPC_BodyInterface_NotifyShapeChanged(atom self,atom bodyID,sequence PrevCenterOfMass,atom UpdateMassProp,JPC_Activation actmode)
	c_proc(xJPC_BodyInterface_NotifyShapeChanged,{self,bodyID,PrevCenterOfMass,UpdateMassProp,actmode})
end procedure

public constant xJPC_BodyInterface_SetObjectLayer = define_c_proc(jolt,"+JPC_BodyInterface_SetObjectLayer",{C_POINTER,JPC_BodyID,JPC_ObjectLayer})

public procedure JPC_BodyInterface_SetObjectLayer(atom self,atom bodyID,atom inLayer)
	c_proc(xJPC_BodyInterface_SetObjectLayer,{self,bodyID,inLayer})
end procedure

public constant xJPC_BodyInterface_GetObjectLayer = define_c_func(jolt,"+JPC_BodyInterface_GetObjectLayer",{C_POINTER,JPC_BodyID},JPC_ObjectLayer)

public function JPC_BodyInterface_GetObjectLayer(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_GetObjectLayer,{self,bodyID})
end function

public constant xJPC_BodyInterface_SetPositionAndRotation = define_c_proc(jolt,"+JPC_BodyInterface_SetPositionAndRotation",{C_POINTER,JPC_BodyID,JPC_RVec3,JPC_Quat,C_INT})

public procedure JPC_BodyInterface_SetPositionAndRotation(atom self,atom bodyID,sequence inPos,sequence inRot,JPC_Activation actmode)
	c_proc(xJPC_BodyInterface_SetPositionAndRotation,{self,bodyID,inPos,inRot,actmode})
end procedure

public constant xJPC_BodyInterface_SetPositionAndRotationWhenChanged = define_c_proc(jolt,"+JPC_BodyInterface_SetPositionAndRotationWhenChanged",{C_POINTER,JPC_BodyID,JPC_RVec3,JPC_Quat,C_INT})

public procedure JPC_BodyInterface_SetPositionAndRotationWhenChanged(atom self,atom bodyID,sequence inPos,sequence inRot,JPC_Activation actmode)
	c_proc(xJPC_BodyInterface_SetPositionAndRotationWhenChanged,{self,bodyID,inPos,inRot,actmode})
end procedure

public constant xJPC_BodyInterface_GetPositionAndRotation = define_c_proc(jolt,"+JPC_BodyInterface_GetPositionAndRotation",{C_POINTER,JPC_BodyID,C_POINTER,C_POINTER})

public procedure JPC_BodyInterface_GetPositionAndRotation(atom self,atom bodyID,atom Pos,atom Rot)
	c_proc(xJPC_BodyInterface_GetPositionAndRotation,{self,bodyID,Pos,Rot})
end procedure

public constant xJPC_BodyInterface_SetPosition = define_c_proc(jolt,"+JPC_BodyInterface_SetPosition",{C_POINTER,JPC_BodyID,JPC_RVec3,C_INT})

public procedure JPC_BodyInterface_SetPosition(atom self,atom bodyID,sequence Pos,JPC_Activation actmode)
	c_proc(xJPC_BodyInterface_SetPosition,{self,bodyID,Pos,actmode})
end procedure

public constant xJPC_BodyInterface_GetPosition = define_c_func(jolt,"+JPC_BodyInterface_GetPosition",{C_POINTER,JPC_BodyID},JPC_RVec3)

public function JPC_BodyInterface_GetPosition(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_GetPosition,{self,bodyID})
end function

public constant xJPC_BodyInterface_GetCenterOfMassPosition = define_c_func(jolt,"+JPC_BodyInterface_GetCenterOfMassPosition",{C_POINTER,JPC_BodyID},JPC_RVec3)

public function JPC_BodyInterface_GetCenterOfMassPosition(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_GetCenterOfMassPosition,{self,bodyID})
end function

public constant xJPC_BodyInterface_SetRotation = define_c_proc(jolt,"+JPC_BodyInterface_SetRotation",{C_POINTER,JPC_BodyID,JPC_Quat,C_INT})

public procedure JPC_BodyInterface_SetRotation(atom self,atom bodyID,sequence inRot,JPC_Activation actmode)
	c_proc(xJPC_BodyInterface_SetRotation,{self,bodyID,inRot,actmode})
end procedure

public constant xJPC_BodyInterface_GetRotation = define_c_func(jolt,"+JPC_BodyInterface_GetRotation",{C_POINTER,JPC_BodyID},JPC_Quat)

public function JPC_BodyInterface_GetRotation(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_GetRotation,{self,bodyID})
end function

public constant xJPC_BodyInterface_MoveKinematic = define_c_proc(jolt,"+JPC_BodyInterface_MoveKinematic",{C_POINTER,JPC_BodyID,JPC_RVec3,JPC_Quat,C_FLOAT})

public procedure JPC_BodyInterface_MoveKinematic(atom self,atom bodyID,sequence TargetPos,sequence TargetRot,atom DeltaTime)
	c_proc(xJPC_BodyInterface_MoveKinematic,{self,bodyID,TargetPos,TargetRot,DeltaTime})
end procedure

public constant xJPC_BodyInterface_SetLinearAndAngularVelocity = define_c_proc(jolt,"+JPC_BodyInterface_SetLinearAndAngularVelocity",{C_POINTER,JPC_BodyID,JPC_Vec3,JPC_Vec3})

public procedure JPC_BodyInterface_SetLinearAndAngularVelocity(atom self,atom bodyID,sequence LinearVel,sequence AngularVel)
	c_proc(xJPC_BodyInterface_SetLinearAndAngularVelocity,{self,bodyID,LinearVel,AngularVel})
end procedure

public constant xJPC_BodyInterface_GetLinearAndAngularVelocity = define_c_proc(jolt,"+JPC_BodyInterface_GetLinearAndAngularVelocity",{C_POINTER,JPC_BodyID,C_POINTER,C_POINTER})

public procedure JPC_BodyInterface_GetLinearAndAngularVelocity(atom self,atom bodyID,atom LinearVel,atom AngularVel)
	c_proc(xJPC_BodyInterface_GetLinearAndAngularVelocity,{self,bodyID,LinearVel,AngularVel})
end procedure

public constant xJPC_BodyInterface_SetLinearVelocity = define_c_proc(jolt,"+JPC_BodyInterface_SetLinearVelocity",{C_POINTER,JPC_BodyID,JPC_Vec3})

public procedure JPC_BodyInterface_SetLinearVelocity(atom self,atom bodyID,sequence LinearVel)
	c_proc(xJPC_BodyInterface_SetLinearVelocity,{self,bodyID,LinearVel})
end procedure

public constant xJPC_BodyInterface_GetLinearVelocity = define_c_func(jolt,"+JPC_BodyInterface_GetLinearVelocity",{C_POINTER,JPC_BodyID},JPC_Vec3)

public function JPC_BodyInterface_GetLinearVelocity(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_GetLinearVelocity,{self,bodyID})
end function

public constant xJPC_BodyInterface_AddLinearVelocity = define_c_proc(jolt,"+JPC_BodyInterface_AddLinearVelocity",{C_POINTER,JPC_BodyID,JPC_Vec3})

public procedure JPC_BodyInterface_AddLinearVelocity(atom self,atom bodyID,sequence LinearVel)
	c_proc(xJPC_BodyInterface_AddLinearVelocity,{self,bodyID,LinearVel})
end procedure

public constant xJPC_BodyInterface_AddLinearAndAngularVelocity = define_c_proc(jolt,"+JPC_BodyInterface_AddLinearAndAngularVelocity",{C_POINTER,JPC_BodyID,JPC_Vec3,JPC_Vec3})

public procedure JPC_BodyInterface_AddLinearAndAngularVelocity(atom self,atom bodyID,sequence LinearVel,sequence AngularVel)
	c_proc(xJPC_BodyInterface_AddLinearAndAngularVelocity,{self,bodyID,LinearVel,AngularVel})
end procedure

public constant xJPC_BodyInterface_SetAngularVelocity = define_c_proc(jolt,"+JPC_BodyInterface_SetAngularVelocity",{C_POINTER,JPC_BodyID,JPC_Vec3})

public procedure JPC_BodyInterface_SetAngularVelocity(atom self,atom bodyID,sequence AngularVel)
	c_proc(xJPC_BodyInterface_SetAngularVelocity,{self,bodyID,AngularVel})
end procedure

public constant xJPC_BodyInterface_GetAngularVelocity = define_c_func(jolt,"+JPC_BodyInterface_GetAngularVelocity",{C_POINTER,JPC_BodyID},JPC_Vec3)

public function JPC_BodyInterface_GetAngularVelocity(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_GetAngularVelocity,{self,bodyID})
end function

public constant xJPC_BodyInterface_GetPointVelocity = define_c_func(jolt,"+JPC_BodyInterface_GetPointVelocity",{C_POINTER,JPC_BodyID,JPC_RVec3},JPC_Vec3)

public function JPC_BodyInterface_GetPointVelocity(atom self,atom bodyID,sequence Point)
	return c_func(xJPC_BodyInterface_GetPointVelocity,{self,bodyID,Point})
end function

public constant xJPC_BodyInterface_SetPositionRotationAndVelocity = define_c_proc(jolt,"+JPC_BodyInterface_SetPositionRotationAndVelocity",{C_POINTER,JPC_BodyID,JPC_RVec3,JPC_Quat,JPC_Vec3,JPC_Vec3})

public procedure JPC_BodyInterface_SetPositionRotationAndVelocity(atom self,atom bodyID,sequence Pos,sequence Rot,sequence LinearVel,sequence AngularVel)
	c_proc(xJPC_BodyInterface_SetPositionRotationAndVelocity,{self,bodyID,Pos,Rot,LinearVel,AngularVel})
end procedure

public constant xJPC_BodyInterface_AddForce = define_c_proc(jolt,"+JPC_BodyInterface_AddForce",{C_POINTER,JPC_BodyID,JPC_Vec3})

public procedure JPC_BodyInterface_AddForce(atom self,atom bodyID,sequence Force)
	c_proc(xJPC_BodyInterface_AddForce,{self,bodyID,Force})
end procedure

public constant xJPC_BodyInterface_AddTorque = define_c_proc(jolt,"+JPC_BodyInterface_AddTorque",{C_POINTER,JPC_BodyID,JPC_Vec3})

public procedure JPC_BodyInterface_AddTorque(atom self,atom bodyID,sequence Torque)
	c_proc(xJPC_BodyInterface_AddTorque,{self,bodyID,Torque})
end procedure

public constant xJPC_BodyInterface_AddForceAndTorque = define_c_proc(jolt,"+JPC_BodyInterface_AddForceAndTorque",{C_POINTER,JPC_BodyID,JPC_Vec3,JPC_Vec3})

public procedure JPC_BodyInterface_AddForceAndTorque(atom self,atom bodyID,sequence Force,sequence Torque)
	c_proc(xJPC_BodyInterface_AddForceAndTorque,{self,bodyID,Force,Torque})
end procedure

public constant xJPC_BodyInterface_AddImpulse = define_c_proc(jolt,"+JPC_BodyInterface_AddImpulse",{C_POINTER,JPC_BodyID,JPC_Vec3})

public procedure JPC_BodyInterface_AddImpulse(atom self,atom bodyID,sequence Impulse)
	c_proc(xJPC_BodyInterface_AddImpulse,{self,bodyID,Impulse})
end procedure

public constant xJPC_BodyInterface_AddImpulse3 = define_c_proc(jolt,"+JPC_BodyInterface_AddImpulse3",{C_POINTER,JPC_BodyID,JPC_Vec3,JPC_RVec3})

public procedure JPC_BodyInterface_AddImpulse3(atom self,atom bodyID,sequence Impulse,sequence Point)
	c_proc(xJPC_BodyInterface_AddImpulse3,{self,bodyID,Impulse,Point})
end procedure

public constant xJPC_BodyInterface_AddAngularImpulse = define_c_proc(jolt,"+JPC_BodyInterface_AddAngularImpulse",{C_POINTER,JPC_BodyID,JPC_Vec3})

public procedure JPC_BodyInterface_AddAngularImpulse(atom self,atom bodyID,sequence AngularImp)
	c_proc(xJPC_BodyInterface_AddAngularImpulse,{self,bodyID,AngularImp})
end procedure

public constant xJPC_BodyInterface_GetBodyType = define_c_func(jolt,"+JPC_BodyInterface_GetBodyType",{C_POINTER,JPC_BodyID},C_INT)

public function JPC_BodyInterface_GetBodyType(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_GetBodyType,{self,bodyID})
end function

public constant xJPC_BodyInterface_SetMotionTyp = define_c_proc(jolt,"+JPC_BodyInterface_SetMotionTyp",{C_POINTER,JPC_BodyID,C_INT,C_INT})

public procedure JPC_BodyInterface_SetMotionTyp(atom self,atom bodyID,JPC_MotionType Motion,JPC_Activation actmode)
	c_proc(xJPC_BodyInterface_SetMotionTyp,{self,bodyID,Motion,actmode})
end procedure

public constant xJPC_BodyInterface_GetMotionType = define_c_func(jolt,"+JPC_BodyInterface_GetMotionType",{C_POINTER,JPC_BodyID},C_INT)

public function JPC_BodyInterface_GetMotionType(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_GetMotionType,{self,bodyID})
end function

public constant xJPC_BodyInterface_SetMotionQuality = define_c_proc(jolt,"+JPC_BodyInterface_SetMotionQuality",{C_POINTER,JPC_BodyID,C_INT})

public procedure JPC_BodyInterface_SetMotionQuality(atom self,atom bodyID,JPC_MotionQuality MotionQuality)
	c_proc(xJPC_BodyInterface_SetMotionQuality,{self,bodyID,MotionQuality})
end procedure

public constant xJPC_BodyInterface_GetMotionQuality = define_c_func(jolt,"+JPC_BodyInterface_GetMotionQuality",{C_POINTER,JPC_BodyID},C_INT)

public function JPC_BodyInterface_GetMotionQuality(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_GetMotionQuality,{self,bodyID})
end function

public constant xJPC_BodyInterface_GetInverseInertia = define_c_proc(jolt,"+JPC_BodyInterface_GetInverseInertia",{C_POINTER,JPC_BodyID,C_POINTER})

public procedure JPC_BodyInterface_GetInverseInertia(atom self,atom bodyID,atom Matrix)
	c_proc(xJPC_BodyInterface_GetInverseInertia,{self,bodyID,Matrix})
end procedure

public constant xJPC_BodyInterface_SetRestitution = define_c_proc(jolt,"+JPC_BodyInterface_SetRestitution",{C_POINTER,JPC_BodyID,C_FLOAT})

public procedure JPC_BodyInterface_SetRestitution(atom self,atom bodyID,atom Res)
	c_proc(xJPC_BodyInterface_SetRestitution,{self,bodyID,Res})
end procedure

public constant xJPC_BodyInterface_GetRestitution = define_c_func(jolt,"+JPC_BodyInterface_GetRestitution",{C_POINTER,JPC_BodyID},C_FLOAT)

public function JPC_BodyInterface_GetRestitution(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_GetRestitution,{self,bodyID})
end function

public constant xJPC_BodyInterface_SetFriction = define_c_proc(jolt,"+JPC_BodyInterface_SetFriction",{C_POINTER,JPC_BodyID,C_FLOAT})

public procedure JPC_BodyInterface_SetFriction(atom self,atom bodyID,atom Friction)
	c_proc(xJPC_BodyInterface_SetFriction,{self,bodyID,Friction})
end procedure

public constant xJPC_BodyInterface_GetFriction = define_c_func(jolt,"+JPC_BodyInterface_GetFriction",{C_POINTER,JPC_BodyID},C_FLOAT)

public function JPC_BodyInterface_GetFriction(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_GetFriction,{self,bodyID})
end function

public constant xJPC_BodyInterface_SetGravityFactor = define_c_proc(jolt,"+JPC_BodyInterface_SetGravityFactor",{C_POINTER,JPC_BodyID,C_FLOAT})

public procedure JPC_BodyInterface_SetGravityFactor(atom self,atom bodyID,atom GravityFac)
	c_proc(xJPC_BodyInterface_SetGravityFactor,{self,bodyID,GravityFac})
end procedure

public constant xJPC_BodyInterface_GetGravityFactor = define_c_func(jolt,"+JPC_BodyInterface_GetGravityFactor",{C_POINTER,JPC_BodyID},C_FLOAT)

public function JPC_BodyInterface_GetGravityFactor(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_GetGravityFactor,{self,bodyID})
end function

public constant xJPC_BodyInterface_SetUseManifoldReduction = define_c_proc(jolt,"+JPC_BodyInterface_SetUseManifoldReduction",{C_POINTER,JPC_BodyID,C_BOOL})

public procedure JPC_BodyInterface_SetUseManifoldReduction(atom self,atom bodyID,atom UseReduction)
	c_proc(xJPC_BodyInterface_SetUseManifoldReduction,{self,bodyID,UseReduction})
end procedure

public constant xJPC_BodyInterface_GetUseManifoldReduction = define_c_func(jolt,"+JPC_BodyInterface_GetUseManifoldReduction",{C_POINTER,JPC_BodyID},C_BOOL)

public function JPC_BodyInterface_GetUseManifoldReduction(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_GetUseManifoldReduction,{self,bodyID})
end function

public constant xJPC_BodyInterface_GetUserData = define_c_func(jolt,"+JPC_BodyInterface_GetUserData",{C_POINTER,JPC_BodyID},C_UINT64),
				xJPC_BodyInterface_SetUserData = define_c_proc(jolt,"+JPC_BodyInterface_SetUserData",{C_POINTER,JPC_BodyID,C_UINT64})
				
public function JPC_BodyInterface_GetUserData(atom self,atom bodyID)
	return c_func(xJPC_BodyInterface_GetUserData,{self,bodyID})
end function

public procedure JPC_BodyInterface_SetUserData(atom self,atom bodyID,atom userData)
	c_proc(xJPC_BodyInterface_SetUserData,{self,bodyID,userData})
end procedure

public constant xJPC_BodyInterface_InvalidateContactCache = define_c_proc(jolt,"+JPC_BodyInterface_InvalidateContactCache",{C_POINTER,JPC_BodyID})

public procedure JPC_BodyInterface_InvalidateContactCache(atom self,atom bodyID)
	c_proc(xJPC_BodyInterface_InvalidateContactCache,{self,bodyID})
end procedure

public constant JPC_NarrowPhaseQuery = C_POINTER --typedef struct

public constant JPC_NarrowPhaseQuery_CastRayArgs = define_c_struct({
	JPC_RRayCast, --ray
	JPC_RayCastResult, --Result
	C_POINTER, --boradphaseLayerFilter
	C_POINTER, --ObjectLayerFilter
	C_POINTER --BodyFilter
})

public constant xJPC_NarrowPhaseQuery_CastRay = define_c_func(jolt,"+JPC_NarrowPhaseQuery_CastRay",{C_POINTER,C_POINTER},C_BOOL)

--self JPC_NarrowPhaseQuery*, args JPC_NarrowPhaseQuery_CastRayArgs*
public function JPC_NarrowPhaseQuery_CastRay(atom self,atom args)
	return c_func(xJPC_NarrowPhaseQuery_CastRay,{self,args})
end function

public constant JPC_PhysicsSystem = C_POINTER

public constant xJPC_PhysicsSystem_new = define_c_func(jolt,"+JPC_PhysicsSystem_new",{},C_POINTER)

public function JPC_PhysicsSystem_new()
	return c_func(xJPC_PhysicsSystem_new,{})
end function

public constant xJPC_PhysicsSystem_delete = define_c_proc(jolt,"+JPC_PhysicsSystem_delete",{C_POINTER})

public procedure JPC_PhysicsSystem_delete(atom obj)
	c_proc(xJPC_PhysicsSystem_delete,{obj})
end procedure

public constant xJPC_PhysicsSystem_Init = define_c_proc(jolt,"+JPC_PhysicsSystem_Init",{C_POINTER,C_UINT,C_UINT,C_UINT,C_UINT,C_POINTER,C_POINTER,C_POINTER})

public procedure JPC_PhysicsSystem_Init(atom self,atom MaxBodies,atom NumBodyMutexes,atom MaxBodyPairs,atom MaxContactConstraints,atom BroadPhaseLayerInterface,atom ObjectVsBroadPhaseLayerFilter,atom ObjectLayerPairFilter)
	c_proc(xJPC_PhysicsSystem_Init,{self,MaxBodies,NumBodyMutexes,MaxBodyPairs,MaxContactConstraints,BroadPhaseLayerInterface,ObjectVsBroadPhaseLayerFilter,ObjectLayerPairFilter})
end procedure

public constant xJPC_PhysicsSystem_OptimizeBroadPhase = define_c_proc(jolt,"+JPC_PhysicsSystem_OptimizeBroadPhase",{C_POINTER})

public procedure JPC_PhysicsSystem_OptimizeBroadPhase(atom self)
	c_proc(xJPC_PhysicsSystem_OptimizeBroadPhase,{self})
end procedure

public constant xJPC_PhysicsSystem_Update = define_c_func(jolt,"+JPC_PhysicsSystem_Update",{C_POINTER,C_FLOAT,C_INT,C_POINTER,C_POINTER},JPC_PhysicsUpdateError)

public function JPC_PhysicsSystem_Update(atom self,atom DeltaTime,atom CollisionSteps,atom TempAlloc,atom JobSys)
	return c_func(xJPC_PhysicsSystem_Update,{self,DeltaTime,CollisionSteps,TempAlloc,JobSys})
end function

public constant xJPC_PhysicsSystem_GetBodyInterface = define_c_func(jolt,"+JPC_PhysicsSystem_GetBodyInterface",{C_POINTER},C_POINTER)

public function JPC_PhysicsSystem_GetBodyInterface(atom self)
	return c_func(xJPC_PhysicsSystem_GetBodyInterface,{self})
end function

public constant xJPC_PhysicsSystem_GetNarrowPhaseQuery = define_c_func(jolt,"+JPC_PhysicsSystem_GetNarrowPhaseQuery",{C_POINTER},C_POINTER)

public function JPC_PhysicsSystem_GetNarrowPhaseQuery(atom self)
	return c_func(xJPC_PhysicsSystem_GetNarrowPhaseQuery,{self})
end function

public constant xJPC_PhysicsSystem_DrawBodies = define_c_proc(jolt,"+JPC_PhysicsSystem_DrawBodies",{C_POINTER,C_POINTER,C_POINTER,C_POINTER})

public procedure JPC_PhysicsSystem_DrawBodies(atom self,atom Settings,atom Renderer,atom BodyFilter)
	c_proc(xJPC_PhysicsSystem_DrawBodies,{self,Settings,Renderer,BodyFilter})
end procedure
­639.21