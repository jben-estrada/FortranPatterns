!Use gfortran factory.f90 -o factory to compile
module factory
	implicit none

	private
	
	public :: shape, circle
	
	type  shape
		character(10) value
	contains
		procedure :: print=>drawAny
	end type shape

    class(shape), pointer :: shapePointer 

    type, public, extends (shape) :: rectangle
    end type rectangle	

    type, public, extends (shape) :: circle
    end type circle	

contains
	
	function getShapePointer() result(sh)
	    class(shape), pointer :: sh
		sh => shapePointer 
	end function
		
	subroutine drawAny(this)
	    class(shape), intent(in) :: this
	    print *, "The item is ", this%value
	end subroutine drawAny
	
end module factory

module assign_mod
	use factory
	implicit none 

	interface assignment(=)
		module procedure assign_sub 
	end interface
	private:: assign_sub
	public:: assignment(=), temp
contains
	subroutine assign_sub(v,e)
	    class(shape), intent(in) :: e
	    class(shape), intent(out), pointer :: v
		allocate(v, source=e)
	end subroutine assign_sub
	
	subroutine temp(str,res)
		character(*), intent(in) :: str
		class(shape), allocatable, intent(out) :: res
		if (str .EQ. 'Rectangle') then
			allocate(res, source=rectangle("Rectangle"))
		else
			allocate(res, source=circle("Circle"))
		endif
	end subroutine temp
end module assign_mod

program shape_interface
	use assign_mod
	use factory
	
    class(shape),allocatable :: sh

	call temp("Rectangle", sh)
	call sh%print

	call temp("Circle", sh)
	call sh%print

	deallocate(sh)
end program shape_interface