<?php

namespace App\Admin\Controllers;

use App\Admin\Controllers\AdminController as Controller;

use App\Models\CurrencyModel;
use App\Models\AccountsModel;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Input;

use Encore\Admin\Controllers\ModelForm;
use Encore\Admin\Facades\Admin;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Layout\Content;

class CurrencyController extends Controller
{
    
    use ModelForm;

    public $curCode;

    /**
     * Index interface.
     *
     * @return Content
     */
    public function wallet(Request $request)
    {
        return Admin::content(function (Content $content) {
            $content->header('钱包管理');
            $content->description('description');
            $content->body($this->grid());
        });
    }

    /**
     * Index interface.
     *
     * @return Content
     */
    public function index(Request $request)
    {
        return Admin::content(function (Content $content) {
            $content->header('币种管理');
            $content->description('description');
            $content->body($this->grid());
        });
    }
    /**
     * Edit interface.
     *
     * @param $id
     *
     * @return Content
     */
    public function edit($id)
    {
        return Admin::content(function (Content $content) use ($id) {
            $content->header('编辑钱包');
            $content->description('description');
            $content->body($this->form()->edit($id));
        });
    }
    /**
     * Create interface.
     *
     * @return Content
     */
    public function create()
    {
        return Admin::content(function (Content $content) {
            $content->header('新增钱包');
            $content->body($this->form());
        });
    }
    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        return Admin::grid(CurrencyModel::class, function (Grid $grid) {

            $grid->id('ID')->sortable();

            $grid->name('名称');
            $grid->code('代号');
            $grid->is_virtual('是否虚拟币')->display(function ($isVirtual){
            	if($isVirtual == 1) {
            		return '<code class="badge bg-blue">是</code>';
            	} else {
            		return '<code class="badge bg-green">否</code>';
            	}
            });
            // $grid->column('last_price', '最新价格')->display(function () {
            //     return 0;
            // });
            $grid->column('market_total', '市场总量')->display(function () {
                $sum = (new AccountsModel())->getCurrencySum($this->id);
                return my_format_money($sum) . '万';
            });
            $grid->created_at('创建时间');
            // $grid->updated_at();
            
            

            // $routeAction = \Route::current()->getActionName();
            // $routeArr = explode('@', $routeAction);
            // $actName = end($routeArr);
            // if($actName != 'index') {
                $grid->disableCreation();
              
                $states = [
                    'on'  => ['value' => 1, 'text' => '启用', 'color' => 'primary'],
                    'off' => ['value' => 0, 'text' => '关闭', 'color' => 'default'],
                ];
                $grid->status('开启状态')->switch($states);
            // }

            $grid->filter(function ($filter) {
            	// 去掉默认的id过滤器
    			  $filter->disableIdFilter();
                $filter->like('name', '货币名称');
                $filter->like('code', '代号');
            });

            $grid->tools(function (Grid\Tools $tools) {
                $tools->batch(function (Grid\Tools\BatchActions $actions) {
                    $actions->disableDelete();
                });
            });

            // $grid->actions(function (Grid\Displayers\Actions $actions) {
            //     $routeAction = \Route::current()->getActionName();
            //     $routeArr = explode('@', $routeAction);
            //     $actName = end($routeArr);
            //     if($actName != 'index') {
            //       $actions->disableEdit();
            //       $actions->disableDelete();
            //     }
            // });
            $grid->disableExport();
            $grid->disableRowSelector();
        });
    }

    protected function forms()
    {
        Form::extend('map', Form\Field\Map::class);
        Form::extend('editor', Form\Field\Editor::class);
        return Admin::form(CurrencyModel::class, function (Form $form) {

            $form->disableDeletion();

            $states = [
                'on'  => ['value' => 1, 'text' => '开启', 'color' => 'success'],
                'off' => ['value' => 0, 'text' => '关闭', 'color' => 'danger'],
            ];

            // 基本资料
            $form->display('id', 'ID');
            $form->image('logo')->move('currencies');
            // $form->image('logo', 'LOGO');
            $form->text('code', '代号')->rules('required')->help('请录入小写字母');
            $form->text('name', '货币名称')->rules('required');
            $form->text('symbol', '货币符号');
            $form->text('decimals', '小数点');
            $form->text('min_trading_val', '最小交易额');
            $form->text('trading_service_rate', '交易手续费率');
            $form->text('withdraw_service_charge', '提现手续费');
            $form->text('fee', '旷工费')->help('底层提现旷工费用');
            // $form->number('confirmations', '网络确认');
            $form->switch('is_virtual', '是否虚拟币')->states([
                'on'  => ['value' => true, 'text' => '是', 'color' => 'success'],
                'off' => ['value' => false, 'text' => '否', 'color' => 'danger'],
            ]);
            
            $form->switch('enable_deposit', '开启充值')->states($states);
            $form->switch('enable_withdraw', '开启提现')->states($states);
            $form->switch('is_base_currency', '基础货币')->states($states);
            $form->switch('status', '是否启用')->states($states);

            $form->display('created_at', '创建时间');
            $form->display('updated_at', '更新时间');
            
            $form->saving(function (Form $form) {
                $form->code = strtoupper($form->code);
            });
        });
    }


    public function form()
    {
        Form::extend('map', Form\Field\Map::class);
        Form::extend('editor', Form\Field\Editor::class);
        return CurrencyModel::form(function (Form $form) { 

            $form->tab('基础信息', function (Form $form) {

                $form->disableDeletion();

                $states = [
                    'on'  => ['value' => 1, 'text' => '开启', 'color' => 'success'],
                    'off' => ['value' => 0, 'text' => '关闭', 'color' => 'danger'],
                ];

                // 基本资料
                $form->display('id', 'ID');
                $form->image('logo')->move('currencies');
                // $form->image('logo', 'LOGO');
                $form->text('code', '代号')->rules('required')->help('请录入小写字母');
                $form->text('name', '货币名称')->rules('required');
                // $form->text('symbol', '货币符号');
                $form->switch('is_virtual', '是否虚拟币')->states([
                    'on'  => ['value' => true, 'text' => '是', 'color' => 'success'],
                    'off' => ['value' => false, 'text' => '否', 'color' => 'danger'],
                ]);
                $form->switch('is_base_currency', '基础货币')->states($states);
                
                $form->switch('status', '是否启用')->states($states);

                $form->display('created_at', '创建时间');
                $form->display('updated_at', '更新时间');
                
                $form->saving(function (Form $form) {
                    $form->code = strtoupper($form->code);
                });

            })->tab('交易设置', function (Form $form) {
              $states = [
                'on'  => ['value' => 1, 'text' => '开启', 'color' => 'success'],
                'off' => ['value' => 0, 'text' => '关闭', 'color' => 'danger'],
              ];
              $form->text('decimals', '小数点');
              $form->text('min_trading_val', '最小交易额');
              $form->text('trading_service_rate', '交易手续费率');
              $form->text('withdraw_service_charge', '提现手续费');
              $form->text('fee', '旷工费')->help('底层提现旷工费用（单位：ETH）');
              // $form->number('confirmations', '网络确认');
              $form->switch('enable_deposit', '开启充值')->states($states);
              $form->switch('enable_withdraw', '开启提现')->states($states);
              


            })->tab('安全设置', function (Form $form) {
              $states = [
                'on'  => ['value' => 1, 'text' => '开启', 'color' => 'success'],
                'off' => ['value' => 0, 'text' => '关闭', 'color' => 'danger'],
              ];
              $form->text('up_number_audit', '充值审核');
              $form->text('extract_number_audit', '提现审核');
              $form->text('transfer_number', '转币额度');

            });
            
            
        });
    }

    // public function destroy($id)
    // {
    //     $ids = explode(',', $id);

    //     if (User::deleteByIds(array_filter($ids))) {
    //         return response()->json([
    //             'status'  => true,
    //             'message' => trans('admin.delete_succeeded'),
    //         ]);
    //     } else {
    //         return response()->json([
    //             'status'  => false,
    //             'message' => trans('admin.delete_failed'),
    //         ]);
    //     }
    // }
}