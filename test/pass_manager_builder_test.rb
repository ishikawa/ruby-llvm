require 'test_helper'
require 'llvm/config'
require 'llvm/transforms/builder'

class PassManagerBuilderTest < Minitest::Test
  def setup
    LLVM.init_jit
    @builder = LLVM::PassManagerBuilder.new

    machine = LLVM::Target.by_name('x86-64').create_machine('x86-linux-gnu')
    @pass_manager = LLVM::PassManager.new(machine)
  end

  def teardown
    @builder.dispose
    @pass_manager.dispose
  end

  def test_init
    assert_equal  0,     @builder.size_level
    assert_equal  0,     @builder.opt_level
    assert_equal  false, @builder.unit_at_a_time
    assert_equal  false, @builder.unroll_loops
    assert_equal  false, @builder.simplify_lib_calls
    assert_equal  0,     @builder.inliner_threshold
  end

  def test_opt_level
    @builder.opt_level = 3
    assert_equal 3, @builder.opt_level
  end

  def test_build
    @builder.build(@pass_manager)
  end

  def test_build_with_lto
    assert_output('', '') do
      @builder.build_with_lto(@pass_manager)
    end
  end

  def test_build_with_lto_deprecated_internalize_param
    assert_output("", "Warning: Passing Integer value to LLVM::PassManagerBuilder#build_with_lto is deprecated.\n") do
      @builder.build_with_lto(@pass_manager, 0)
    end
  end

  def test_build_with_lto_deprecated_run_inliner_param
    assert_output("", "Warning: Passing Integer value to LLVM::PassManagerBuilder#build_with_lto is deprecated.\n") do
      @builder.build_with_lto(@pass_manager, false, 0)
    end
  end
end
