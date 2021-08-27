import numpy as np


# Input: expects Nx3 matrix of points
# Returns R,t
# R = 3x3 rotation matrix
# t = 3x1 column vector

def rigid_transform_3D(A, B):
    assert len(A) == len(B)

    N = A.shape[0]  # total points

    centroid_A = np.mean(A, axis=0)
    centroid_B = np.mean(B, axis=0)

    # centre the points
    AA = A - np.tile(centroid_A, (N, 1))
    BB = B - np.tile(centroid_B, (N, 1))

    H = np.matmul(np.transpose(AA), BB)

    U, S, Vt = np.linalg.svd(H)

    R = np.matmul(Vt.T, U.T)

    # special reflection case
    if np.linalg.det(R) < 0:
        print("Reflection detected")
        Vt[2, :] *= -1
        R = np.matmul(Vt.T, U.T)

    t = -np.matmul(R, centroid_A) + centroid_B
    return R, t


1
if __name__ == '__main__':
    #栏杆

    a = np.array([[0.10395, 1.236, 2.624],
                  [0.061423, 0.37598, 2.645],
                  [0.02556, -0.47713, 2.673],
                  ])

    b = np.array([[-1.3928, 1.9077, 3.365],
                  [-1.4342, 1.031, 3.333],
                  [-1.4185, 0.13981, 3.215]])
    # a = np.array([[-0.23116, 1.0536, 3.318],
    #               [-0.28658,0.19957,3.33],
    #               [0.032531, -0.79138, 2.646],
    #               ])
    #
    # b = np.array([[-0.68409, 1.6111,3.502],
    #              [-0.68674, 0.69228, 3.374],
    #              [-1.4374, -0.15797,3.179]])

    # a = np.array([[0.11788, 0.95938, 2.615],
    #               [-0.23283, 1.0521, 3.342],
    #               [0.075675, 0.093031, 2.638],
    #               [-0.28907, 0.1921, 3.359],
    #              [0.039835, -0.79287, 2.651],
    #               [-0.28925, -0.67363, 3.361]])
    #
    # b = np.array([[-1.3936, 1.6289, 3.323],
    #               [-0.67412, 1.6255, 3.451],
    #               [-1.4171, 0.73855, 3.252],
    #               [-0.691, 0.72408, 3.35],
    #               [-1.4359, -0.15001, 3.195],
    #               [-0.70329, -0.1609, 3.238]])
    r, t = rigid_transform_3D(a, b)
    print('r:', r)
    print('t:', t)

#栏杆的
# -0.34376166  0.0971703   0.93401598 -3.84254856
# 0.14698745  0.98793965 -0.04868197 0.66021162
# -0.92748187  0.12055363 -0.35389859 4.23824572
# 0.00000000 0.00000000 0.00000000 1.00000000













