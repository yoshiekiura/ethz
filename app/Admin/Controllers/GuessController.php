<?php

namespace App\Admin\Controllers;

use App\Admin\Controllers\AdminController as Controller;

use App\Models\CurrencyModel;
use App\Models\Guess;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\MessageBag;

use Encore\Admin\Widgets\Table;
use Encore\Admin\Controllers\ModelForm;
use Encore\Admin\Facades\Admin;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Layout\Content;

class GuessController extends Controller
{
    use ModelForm;

    /**
     * Index interface.
     *
     * @return Content
     */
    public function index(Request $request)
    {
        return Admin::content(function (Content $content) {
            $content->header('竞猜项目');
            // $content->description('description');
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
            $content->header('编辑竞猜');
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
            $content->header('创建竞猜');
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
        return Admin::grid(Guess::class, function (Grid $grid) {

            $grid->id('ID')->sortable();

            $grid->title('名称');
            $grid->period('周期');
            $grid->currencyTo()->name('币种');
            $grid->expect_price('中奖点数')->display(function($expect_price){
                return my_number_format($expect_price, 4);
            });
            $grid->charges('运营费用')->display(function($charges){
                return my_number_format($charges, 4) . '%';
            });
            $grid->open_time('开奖时间');
            $grid->column('竞猜信息')->expand(function (){
                $id = $this->id;
                $profile['竞猜期数'] = $this->period;

                $profile['竞猜价'] = my_number_format($this->expect_price);
                $profile['平台运营费'] = my_number_format($this->charges) . '%';
                $profile['最大投注'] = my_number_format($this->max_amount);
                $profile['最小投注'] = my_number_format($this->min_amount);

                $profile['开奖时间'] = $this->open_time;
                $profile['开始时间'] = $this->start_time;
                $profile['结束时间'] = $this->end_time;

                return new Table([], $profile);
            }, '展开');
            $grid->created_at('创建时间');

            // $states = [
            //     'on'  => ['value' => 1, 'text' => '启用', 'color' => 'primary'],
            //     'off' => ['value' => 0, 'text' => '关闭', 'color' => 'default'],
            // ];
            // $grid->status('开启状态')->switch($states);

            $grid->disableFilter();
            $grid->disableExport();
            // $grid->disableCreation();
            $grid->disableRowSelector();
            // $grid->filter(function ($filter) {
            	// 去掉默认的id过滤器
    			// $filter->disableIdFilter();
                // $filter->like('name', '货币名称');
                // $filter->like('code', '代号');
            // });
        });
    }


    public function form()
    {
        Form::extend('map', Form\Field\Map::class);
        Form::extend('editor', Form\Field\Editor::class);
        return Admin::form(Guess::class, function (Form $form) {

            $form->tab('基础信息', function (Form $form) {

                $form->disableDeletion();

                // 基本资料
                $form->display('id', 'ID');
                $form->select('currency', '充值货币')->options(CurrencyModel::where(['status' => 1, 'is_virtual' => 1])->get()->pluck('name', 'id'))->rules('required');
                $form->text('title', '竞猜标题')->rules('required');
                $form->text('period', '竞猜期数')->rules('required');
                $form->switch('status', '是否启用')->states([
                    'on'  => ['value' => 1, 'text' => '是', 'color' => 'success'],
                    'off' => ['value' => 0, 'text' => '否', 'color' => 'danger'],
                ]);

                $form->display('created_at', '创建时间');
                $form->display('updated_at', '更新时间');

            })->tab('竞猜设置', function (Form $form) {

              $form->number('expect_price', '竞猜价')->rules('required');
              $form->number('charges', '运营费用')->rules('required');
              $form->number('max_amount', '最大投注数')->rules('required');
              $form->number('min_amount', '最小投注数')->rules('required');

              $form->datetime('open_time', '开奖时间')->rules('required');
              $form->datetime('start_time', '开始时间')->rules('required');
              $form->datetime('end_time', '结束时间')->rules('required');

            });

            $form->saving(function (Form $form) {
                $open_time = $form->open_time ? strtotime($form->open_time) : 0;
                $start_time = $form->start_time ? strtotime($form->start_time) : 0;
                $end_time = $form->end_time ? strtotime($form->end_time) : 0;
                if($start_time > $end_time) {
                    $error = new MessageBag([
                        'message' => '开始时间必须小于结束时间',
                    ]);

                    return back()->with(compact('error'));
                }
                if($start_time >= $open_time || $end_time >= $open_time) {
                    $error = new MessageBag([
                        'message' => '开奖时间必须大于开始时间与结束时间',
                    ]);

                    return back()->with(compact('error'));
                }
                $form->status = $form->status == 'on' ? 1 : 0;
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