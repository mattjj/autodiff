from __future__ import division
import numpy as np

class DualNumber(object):
    def __init__(self,real=None,eps=0,mat=None):
        if mat is not None:
            self._mat = mat
        else:
            self._mat = real*np.eye(2)
            self._mat[0,1] = eps

    @property
    def real(self):
        return self._mat[0,0]

    @property
    def eps(self):
        return self._mat[0,1]

    def __repr__(self):
        if self._mat[0,1] == 0:
            return '%g' % self._mat[0,0]
        else:
            return '%g + %g e' % tuple(self._mat[0])

    def __add__(self,other):
        if isinstance(other,DualNumber):
            return DualNumber(mat=self._mat + other._mat)
        else:
            return self.__radd__(other)

    def __radd__(self,a):
        return DualNumber(mat=self._mat + a*np.eye(2))

    def __mul__(self,other):
        if isinstance(other,DualNumber):
            return DualNumber(mat=self._mat.dot(other._mat))
        else:
            return self.__rmul__(other)

    def __rmul__(self,a):
        return DualNumber(mat=a*self._mat)

    def __neg__(self):
        return DualNumber(mat=-self._mat)

    def __sub__(self,other):
        if isinstance(other,DualNumber):
            return DualNumber(mat=self._mat - other._mat)
        else:
            return self.__rsub__(other)

    def __rsub__(self,a):
        return DualNumber(mat=a*np.eye(2) - self._mat)

    def __pow__(self,x):
        if isinstance(x,DualNumber):
            return DualNumber(real=self.real*x.real,eps=self.eps*(x.real*self.real**(x.real-1)) + x.eps*(self.real**(x.eps)*np.log(self.real)))
        else:
            return DualNumber(mat=np.linalg.matrix_power(self._mat,x))

def sin(x):
    if isinstance(x,DualNumber):
        return DualNumber(real=np.sin(x.real),eps=np.cos(x.real)*x.eps)
    else:
        return np.sin(x)

def cos(x):
    if isinstance(x,DualNumber):
        return DualNumber(real=np.cos(x.real),eps=np.sin(x.real)*x.eps)
    else:
        return np.cos(x)

def exp(x):
    if isinstance(x,DualNumber):
        return DualNumber(real=np.exp(x.real),eps=np.exp(x.real)*x.eps)
    else:
        return np.exp(x)

def eps_kth_arg(args,k):
    if not isinstance(args,list):
        args = list(args)
    newargs = args[:]
    newargs[k] = DualNumber(args[k],eps=1)
    return newargs

def D(f):
    def Df(*args):
        return np.array([f(*eps_kth_arg(args,k)).eps for k in range(len(args))])
    return Df

