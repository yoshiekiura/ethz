<?php

namespace App\Admin\Controllers;

use App\Admin\Controllers\AdminController as Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Input;

use Encore\Admin\Controllers\ModelForm;
use Encore\Admin\Facades\Admin;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Layout\Content;
use App\Admin\Extensions\LandSelected;
use Encore\Admin\Form\Builder;
use App\Models\News;

class NewsController extends Controller
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
            $content->header('资讯管理');
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
            $content->header('编辑资讯');
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
            $content->header('创建资讯');
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
        $_GET['is_delete'] = 0;
        return Admin::grid(News::class, function (Grid $grid) {
            $grid->id('ID')->sortable();
            $grid->displayorder('排序')->editable('text');
            $grid->title('标题');
            $grid->status('状态')->display(function ($status) {
                return $status == 'ACTIVE' ? '发布' :'未发布';
            });
            $grid->created_at('创建时间');
            // $grid->updated_at();

            $grid->filter(function ($filter) {
                // 去掉默认的id过滤器
                $filter->disableIdFilter();
                $filter->like('title', '标题');
            });

            $grid->tools(function (Grid\Tools $tools) {
                // $tools->append(new LandSelected('en','news'));
                $tools->batch(function (Grid\Tools\BatchActions $actions) {
                    $actions->disableDelete();
                });
            });
        });
    }
    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        Form::extend('map', Form\Field\Map::class);
        Form::extend('editor', Form\Field\Editor::class);
        return Admin::form(News::class, function (Form $form) {

            $form->disableDeletion();
            $form->display('id', 'ID');
            $form->text('displayorder', '排序');
            $form->text('title', '文章名称');
            $form->textarea('description', '简介')->rows(3);
            $form->editor('content', '内容');
            $form->hidden('author_id')->default(function ($form) {
                    return Admin::user()->id;
                });

            $states = [
                'on'  => ['value' => 'ACTIVE', 'text' => '发布', 'color' => 'success'],
                'off' => ['value' => 'INACTIVE', 'text' => '不发布', 'color' => 'danger'],
            ];
            $form->switch('status', '发布状态')->states($states)->default('on');
            $form->saving(function (Form $form) {
                if($form->status == 'on') {
                    $form->status = 'ACTIVE';
                } else {
                    $form->status = 'INACTIVE';
                }
            });

            $form->display('created_at', '创建时间');
            $form->display('updated_at', '更新时间');
        });
    }
}
