struct Matrix4x4 {
    
    float Matrix[4][4];

    float *operator[](int index) {
        return Matrix[index];
    }

    Matrix4x4 Mult(Matrix4x4 m1, Matrix4x4 m2)
    {
        Matrix4x4 matrix = Matrix4x4();
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                for (int k = 0; k < 4; k++) {
                    matrix[i][j] += m1[i][k] * m2[k][j];
                }
            }
        }
        return matrix;
    }

};