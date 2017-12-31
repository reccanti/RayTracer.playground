import Foundation

/**
 * Vec3 and related math functions
 */
struct vec3 {
    var x = 0.0
    var y = 0.0
    var z = 0.0
}

func * (left: Double, right: vec3) -> vec3 {
    return vec3(x: left * right.x,
                y: left * right.y,
                z: left * right.z)
}

func + (left: vec3, right: vec3) -> vec3 {
    return vec3(x: left.x + right.x,
                y: left.y + right.y,
                z: left.z + right.z)
}

func - (left: vec3, right: vec3) -> vec3 {
    return vec3(x: left.x - right.x,
                y: left.y - right.y,
                z: left.z - right.z)
}

func dot (_ left: vec3, _ right: vec3) -> Double {
    return left.x * right.x + left.y * right.y + left.z * right.z
}

func unit_vector(_ v: vec3) -> vec3 {
    let length: Double = sqrt(dot(v, v))
    return vec3(x: v.x/length, y: v.y/length, z: v.z/length)
}

/**
 * Ray and related functions
 */
struct ray {
    var origin: vec3
    var direction: vec3
    
    // get a point along the direction of the ray
    func point_at_parameter (_ t: Double) -> vec3 {
        return origin + t * direction
    }
}

// JUST COPYING CODE I DON'T KNOW WHAT'S HAPPENNING HERE MUST RESEARCH!!!

func color(_ r: ray) -> vec3 {
    let minusZ = vec3(x: 0, y: 0, z: -1)
    var t = hit_sphere(minusZ, 0.5, r)  // determines if the ray hits a sphere with the origin at minusZ with a radius of 0.5
    
    // guessing ambient light?
    if t > 0.0 {
        let norm = unit_vector(r.point_at_parameter(t) - minusZ)
        return 0.5 * vec3(x: norm.x + 1.0, y: norm.y + 1.0, z: norm.z + 1.0)
    }
    
    let unit_direction = unit_vector(r.direction)
    t = 0.5 * (unit_direction.y + 1.0)
    return (1.0 - t) * vec3(x: 1.0, y: 1.0, z: 1.0) + t * vec3(x: 0.5, y: 0.7, z: 1.0)
}

/**
 * Determines if a given ray hits a sphere at the given center locationa
 * with the given radius. Uses an analytic approach:
 * https://www.scratchapixel.com/lessons/3d-basic-rendering/minimal-ray-tracer-rendering-simple-shapes/ray-sphere-intersection
 *
 * an implicit function
 */
func hit_sphere (_ center: vec3, _ radius: Double, _ r: ray) -> Double {
    
    // 1. Any point on the surface of a sphere corresponds to the equation P^2 - R^2 = 0
    // 2. A point on a ray that intersects with a sphere would correspond to |O + tD|^2 - R^2 = 0
    // 3. This can be expanded to the O^2 + t^2D^2 + 2OtD - R^2 = 0
    // 4. This is the quadratic formula t^2D^2 + 2OtD + (O^2 - R^2) = 0
    let oc = r.origin - center
    let a = dot(r.direction, r.direction)   // t^2D^2
    let b = 2.0 * dot(oc, r.direction)      // 2OtD
    let c = dot(oc, oc) - radius * radius   // (O^2 - R^2)
    let discriminant = b * b - 4 * a * c
    
    if discriminant < 0 {
        return -1.0 // return -1.0 if the discriminant is real
    } else {
        return (-b - sqrt(discriminant)) / (2.0 * a) // quadratic formula
    }
}
